local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.openshift4_elasticsearch_operator;

local group = 'operators.coreos.com/';

{
  '00_namespace': kube.Namespace(params.namespace) {
    metadata+: {
      annotations+: {
        'openshift.io/node-selector': '',
      },
      labels+: {
        'openshift.io/cluster-monitoring': 'true',
      },
    },
  },
  '10_operator_group': kube._Object(group + 'v1', 'OperatorGroup', 'openshift-operators-redhat') {
    metadata+: {
      namespace: params.namespace,
    },
    spec: {
      targetNamespaces: params.targetNamespaces,
    },
  },
  '20_subscription': kube._Object(group + 'v1alpha1', 'Subscription', 'elasticsearch-operator') {
    local name = self.metadata.name,
    metadata+: {
      namespace+: params.namespace,
    },
    spec: {
      channel: params.channel,
      installPlanApproval: 'Automatic',
      name: name,
      source: 'redhat-operators',
      sourceNamespace: 'openshift-marketplace',
    },
  },
}
