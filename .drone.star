def main(ctx):
  versions = [
    'latest',
    '3.10',
    '3.9',
  ]

  arches = [
    'amd64',
    'arm32v7',
    'arm64v8',
  ]

  stages = []

  for version in versions:
    for arch in arches:
      stages.append(docker(ctx, version, arch))
    stages.append(manifest(ctx, version, arches))

  after = [
    microbadger(ctx),
    rocketchat(ctx),
  ]

  for s in stages:
    for a in after:
      a['depends_on'].append(s['name'])

  return stages + after

def docker(ctx, version, arch):
  if version == 'latest':
    prefix = 'latest'
    tag = arch
  else:
    prefix = 'v%s' % version
    tag = '%s-%s' % (version, arch)

  if arch == 'amd64':
    platform = 'amd64'
    variant = ''

  if arch == 'arm64v8':
    platform = 'arm64'
    variant = 'v8'

  if arch == 'arm32v7':
    platform = 'arm'
    variant = 'v7'

  prepublish = '%s-%s' % (ctx.build.commit, tag)

  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': '%s-%s' % (arch, prefix),
    'platform': {
      'os': 'linux',
      'arch': platform,
      'variant': variant,
    },
    'steps': [
      {
        'name': 'prepublish',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'internal_username',
          },
          'password': {
            'from_secret': 'internal_password',
          },
          'tags': prepublish,
          'dockerfile': '%s/Dockerfile.%s' % (prefix, arch),
          'repo': 'registry.drone.owncloud.com/build/alpine',
          'registry': 'registry.drone.owncloud.com',
          'context': prefix,
          'purge': False,
        },
        'volumes': [
          {
            'name': 'docker',
            'path': '/var/lib/docker'
          },
        ],
      },
      {
        'name': 'sleep',
        'image': 'toolhippie/reg:latest',
        'pull': 'always',
        'environment': {
          'DOCKER_USER': {
            'from_secret': 'internal_username',
          },
          'DOCKER_PASSWORD': {
            'from_secret': 'internal_password',
          },
        },
        'commands': [
          'retry -- reg digest --username $DOCKER_USER --password $DOCKER_PASSWORD registry.drone.owncloud.com/build/alpine:%s' % prepublish,
        ],
      },
      {
        'name': 'clair',
        'image': 'toolhippie/klar:latest',
        'pull': 'always',
        'environment': {
          'CLAIR_ADDR': 'clair.owncloud.com',
          'CLAIR_OUTPUT': 'High',
          'CLAIR_TIMEOUT': '5',
          'DOCKER_USER': {
            'from_secret': 'internal_username',
          },
          'DOCKER_PASSWORD': {
            'from_secret': 'internal_password',
          },
        },
        'commands': [
          'klar registry.drone.owncloud.com/build/base:%s' % prepublish,
        ],
      },
      {
        'name': 'publish',
        'image': 'plugins/docker',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'public_username',
          },
          'password': {
            'from_secret': 'public_password',
          },
          'tags': tag,
          'dockerfile': '%s/Dockerfile.%s' % (prefix, arch),
          'repo': 'owncloud/alpine',
          'context': prefix,
        },
        'volumes': [
          {
            'name': 'docker',
            'path': '/var/lib/docker'
          },
        ],
        'when': {
          'ref': [
            'refs/heads/master',
          ],
        },
      },
      {
        'name': 'cleanup',
        'image': 'toolhippie/reg:latest',
        'pull': 'always',
        'failure': 'ignore',
        'environment': {
          'DOCKER_USER': {
            'from_secret': 'internal_username',
          },
          'DOCKER_PASSWORD': {
            'from_secret': 'internal_password',
          },
        },
        'commands': [
          'reg rm --username $DOCKER_USER --password $DOCKER_PASSWORD registry.drone.owncloud.com/build/alpine:%s' % prepublish,
        ],
        'when': {
          'status': [
            'success',
            'failure'
          ]
        }
      },
    ],
    'volumes': [
      {
        'name': 'docker',
        'temp': {},
      },
    ],
    'image_pull_secrets': [
      'dockerconfigjson',
    ],
    'depends_on': [],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/pull/**',
      ],
    },
  }

def manifest(ctx, version, arches):
  if version == 'latest':
    prefix = 'latest'
  else:
    prefix = 'v%s' % version

  depends = []

  for arch in arches:
    depends.append('%s-%s' % (arch, prefix))

  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'manifest-%s' % prefix,
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'steps': [
      {
        'name': 'manifest',
        'image': 'plugins/manifest',
        'pull': 'always',
        'settings': {
          'username': {
            'from_secret': 'public_username',
          },
          'password': {
            'from_secret': 'public_password',
          },
          'spec': '%s/manifest.tmpl' % prefix,
          'ignore_missing': 'true',
        },
      },
    ],
    'depends_on': depends,
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ]
    }
  }

def microbadger(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'microbadger',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'clone': {
      'disable': True,
    },
    'steps': [
      {
        'name': 'notify',
        'image': 'plugins/webhook',
        'pull': 'always',
        'failure': 'ignore',
        'settings': {
          'urls': {
            'from_secret': 'microbadger_url',
          },
        },
      },
    ],
    'depends_on': [],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
    },
  }

def rocketchat(ctx):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'name': 'rocketchat',
    'platform': {
      'os': 'linux',
      'arch': 'amd64',
    },
    'clone': {
      'disable': True,
    },
    'steps': [
      {
        'name': 'notify',
        'image': 'plugins/slack',
        'pull': 'always',
        'failure': 'ignore',
        'settings': {
          'webhook': {
            'from_secret': 'public_rocketchat',
          },
          'channel': 'docker',
        },
      },
    ],
    'depends_on': [],
    'trigger': {
      'ref': [
        'refs/heads/master',
        'refs/tags/**',
      ],
      'status': [
        'changed',
        'failure',
      ],
    },
  }
