require_relative "spec_helper"

DEBUG = false

describe "ConfigMerger" do
  YAML_SOURCE = "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    service: api
  name: api
spec:
  replicas: 4
  selector:
    matchLabels:
      service: api
  strategy: {}
  template:
    metadata:
      labels:
        service: api
    spec:
      containers:
      -
        name: api
        image: appliedblockchain/cult-wines-api:latest
        imagePullPolicy: Always
        ports:
          - containerPort: 3000
        env:
        -
          name: FORCE_COLOR
          value: 1
        -
          name: NODE_ENV
          value: test
        -
          name: SENTRY_DSN
          value: http://xxx
        resources: {}
      hostname: cult-wines-api
      imagePullSecrets:
      -
        name: regcred
      terminationGracePeriodSeconds: 1
      restartPolicy: Always
status: {}
  "

  YAML_OVERRIDE = "
---
spec:
  template:
    spec:
      containers:
      -
        name: api
        image: appliedblockchain/cult-wines-api:staging
        env:
        -
          name: NODE_ENV
          value: staging
        resources: {}
  "

  YAML_OUTPUT = "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    service: api
  name: api
spec:
  replicas: 4
  selector:
    matchLabels:
      service: api
  strategy: {}
  template:
    metadata:
      labels:
        service: api
    spec:
      containers:
      - name: api
        image: appliedblockchain/cult-wines-api:staging
        imagePullPolicy: Always
        ports:
        - containerPort: 3000
        env:
        - name: FORCE_COLOR
          value: 1
        - name: NODE_ENV
          value: staging
        - name: SENTRY_DSN
          value: http://xxx
        resources: {}
      hostname: cult-wines-api
      imagePullSecrets:
      - name: regcred
      terminationGracePeriodSeconds: 1
      restartPolicy: Always
status: {}
  "

  before :all do
    puts `rm -rf #{tmp_path}/*`
    puts `mkdir -p #{tmp_path}/overrides`
    File.write "#{tmp_path}/yaml_file.yml", YAML_SOURCE
    File.write "#{tmp_path}/overrides/yaml_file.yml", YAML_OVERRIDE

    project = { }
    merger = ConfigMerger.new project: project, env_name: "staging"
    def merger.override_dir
      "#{tmp_path}/overrides"
    end

    def merger.stack_path
      tmp_path
    end
    @merger = merger
  end

  it "merges two yamls" do
    source = "#{tmp_path}/yaml_file.yml"
    output = @merger.send :merge_yml_file, source_file: source, file_name: "yaml_file.yml"
    output.should == "#{YAML_OUTPUT.strip}\n"
  end
end
