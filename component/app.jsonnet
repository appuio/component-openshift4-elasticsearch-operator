local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.openshift4_elasticsearch_operator;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('openshift4-elasticsearch-operator', params.namespace, secrets=false);

{
  'openshift4-elasticsearch-operator': app,
}
