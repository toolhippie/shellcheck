def main(ctx):
	return [
		docker(ctx, 'amd64'),
		docker(ctx, 'arm'),
		docker(ctx, 'arm64'),

		manifest(ctx),
		microbadger(ctx),
		matrix(ctx),
	]

def docker(ctx, arch):
	return {
		'kind': 'pipeline',
		'type': 'docker',
		'name': arch,
		'platform': {
			'os': 'linux',
			'arch': arch,
		},
		'steps': [
			{
				'name': 'dryrun',
				'image': 'plugins/docker',
				'pull': 'always',
				'settings': {
					'dry_run': True,
					'dockerfile': 'Dockerfile.%s' % arch,
					'tags': 'latest-%s' % arch,
					'repo': 'toolhippie/%s' % ctx.repo.name,
				},
				'when': {
					'event': {
						'include': [
							'pull_request',
						],
					},
				},
			},
			{
				'name': 'publish',
				'image': 'plugins/docker',
				'pull': 'always',
				'settings': {
					'username': {
						'from_secret': 'docker_username',
					},
					'password': {
						'from_secret': 'docker_password',
					},
					'dockerfile': 'Dockerfile.%s' % arch,
					'tags': 'latest-%s' % arch,
					'repo': 'toolhippie/%s' % ctx.repo.name,
				},
				'when': {
					'event': {
						'exclude': [
							'pull_request',
						],
					},
				},
			},
		],
		'depends_on': [],
		'trigger': {
			'ref': [
				'refs/heads/master',
			],
		},
	}

def manifest(ctx):
	return {
		'kind': 'pipeline',
		'type': 'docker',
		'name': 'manifest',
		'platform': {
			'os': 'linux',
			'arch': 'amd64',
		},
		'clone': {
			'disable': True,
		},
		'steps': [
			{
				'name': 'execute',
				'image': 'plugins/manifest',
				'pull': 'always',
				'settings': {
					'username': {
						'from_secret': 'docker_username',
					},
					'password': {
						'from_secret': 'docker_password',
					},
					'platforms': [
						'linux/amd64',
						'linux/arm',
						'linux/arm64',
					],
					'target': 'toolhippie/%s:latest' % ctx.repo.name,
					'template': 'toolhippie/%s:ARCH' % ctx.repo.name,
					'ignore_missing': True,
				},
			},
		],
		'depends_on': [
			'amd64',
			'arm',
			'arm64',
		],
		'trigger': {
			'ref': [
				'refs/heads/master',
			],
		},
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
				'name': 'execute',
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
		'depends_on': [
			'manifest',
		],
		'trigger': {
			'ref': [
				'refs/heads/master',
			],
		},
	}

def matrix(ctx):
	return {
		'kind': 'pipeline',
		'type': 'docker',
		'name': 'matrix',
		'platform': {
			'os': 'linux',
			'arch': 'amd64',
		},
		'clone': {
			'disable': True,
		},
		'steps': [
			{
				'name': 'execute',
				'image': 'plugins/matrix',
				'pull': 'always',
				'failure': 'ignore',
				'settings': {
					'username': {
						'from_secret': 'matrix_username',
					},
					'password': {
						'from_secret': 'matrix_password',
					},
					'roomid': {
						'from_secret': 'matrix_roomid',
					},
				},
			},
		],
		'depends_on': [
			'microbadger',
		],
		'trigger': {
			'ref': [
				'refs/heads/master',
			],
			'status': [
				'failure',
			],
		},
	}
