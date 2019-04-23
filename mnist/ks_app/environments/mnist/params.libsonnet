local params = std.extVar('__ksonnet/params');
local globals = import 'globals.libsonnet';
local envParams = params + {
  components+: {
    train+: {
      name: 'mnist-train-dist',
      numPs: 1,
      numWorkers: 2,
      modelDir: 's3://turbo-kubeflow/mnist-meng',
      exportDir: 's3://turbo-kubeflow/mnist-meng/export',
      secretKeyRefs: 'AWS_ACCESS_KEY_ID=aws-creds.awsAccessKeyID,AWS_SECRET_ACCESS_KEY=aws-creds.awsSecretAccessKey',
      envVariables: 'S3_ENDPOINT=s3.us-west-2.amazonaws.com,AWS_ENDPOINT_URL=https://s3.us-west-2.amazonaws.com,AWS_REGION=us-west-2,BUCKET_NAME=turbo-kubeflow,S3_USE_HTTPS=1,S3_VERIFY_SSL=1',
      image: 'ading1977/mnist',
      trainSteps: 10000,
    },
    tensorboard+: {
      secretKeyRefs: 'AWS_ACCESS_KEY_ID=aws-creds.awsAccessKeyID,AWS_SECRET_ACCESS_KEY=aws-creds.awsSecretAccessKey',
      logDir: 's3://turbo-kubeflow/mnist-meng',
      envVariables: 'S3_ENDPOINT=s3.us-west-2.amazonaws.com,AWS_ENDPOINT_URL=https://s3.us-west-2.amazonaws.com,AWS_REGION=us-west-2,BUCKET_NAME=turbo-kubeflow,S3_USE_HTTPS=1,S3_VERIFY_SSL=1',
    },
    "mnist-deploy-aws"+: {
      modelBasePath: 's3://turbo-kubeflow/mnist-meng/export',
      s3AwsRegion: 'us-west-2',
      s3Enable: true,
      s3Endpoint: 's3.us-west-2.amazonaws.com',
      s3SecretName: 'aws-creds',
      s3SecretAccesskeyidKeyName: 'awsAccessKeyID',
      s3SecretSecretaccesskeyKeyName: 'awsSecretAccessKey',
      modelName: 'mnist',
    },
    "mnist-service"+: {
      serviceType: 'ClusterIP',
    },
    "web-ui"+: {
      type: 'LoadBalancer',
    },
  },
};

{
  components: {
    [x]: envParams.components[x] + globals
    for x in std.objectFields(envParams.components)
  },
}