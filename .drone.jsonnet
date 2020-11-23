local Pipeline(ServiceName) = {
  kind: 'pipeline',
  type: 'kubernetes',
  name: ServiceName + '-deployjs',
  steps: [
    {
      name: 'publishToEcr',
      image: 'plugins/ecr',
      settings: {
        dockerfile: ServiceName + '/Dockerfile',
        mirror: 'http://34.229.17.151:7000',
        access_key: {
          from_secret: 'aws_access_key_id',
        },
        secret_key: {
          from_secret: 'aws_secret_access_key',
        },
        repo: 'drone-test/' + ServiceName,
        registry: '624792314775.dkr.ecr.us-east-1.amazonaws.com',
        region: 'us-east-1',
        tags: [
          '${DRONE_COMMIT_SHA:0:8}',
          '${DRONE_BRANCH}',
        ],
      },
      when: {
        event: ['push'],
        branch: ['main'],
      },
    },
    {
      name: 'deployT0K8s',
      image: 'quay.io/honestbee/drone-kubernetes',
      settings: {
        KUBERNETES_SERVER: {
          from_secret: 'kubernetes_server',
        },
        KUBERNETES_TOKEN: {
          from_secret: 'kubernetes_token',
        },
        KUBERNETES_CERT: {
          from_secret: 'kubernetes_cert',
        },
        namespace: 'dronetest',
        deployment: ServiceName,
        repo: '624792314775.dkr.ecr.us-east-1.amazonaws.com/drone-test/' + ServiceName,
        container: ServiceName,
        tag: '${DRONE_COMMIT_SHA:0:8}',
      },
      when: {
        event: ['push'],
        branch: ['main'],
      },
    },
  ],
};


local whenCommitToNonMaster(step) = step {
  trigger: {
    branch: [
      'main',
    ],
  },
};

[
  whenCommitToNonMaster(Pipeline('service1')),
  Pipeline('service2'),
]
