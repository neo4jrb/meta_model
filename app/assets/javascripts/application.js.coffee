#= require lodash
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require meta_model

# for more details see: http://emberjs.com/guides/application/
window.MetaModel = Ember.Application.create()

MetaModel.Model = DS.Model.extend()

MetaModel.MetaModelAdapter = DS.RESTAdapter.extend
  namespace: 'meta'

MetaModel.ModelAdapter = MetaModel.MetaModelAdapter.extend()
MetaModel.PropertyAdapter = MetaModel.MetaModelAdapter.extend()

MetaModel.Router.map ->
  @route 'index', path: "/"

  @resource 'models', path: '/', ->
    @route 'hierarchy', path: '/'
    @route 'index', path: '/:class_name'
    @route 'edit', path: "/:class_name/edit"


  @resource 'meta-models', path: '/models', ->
    @route 'hierarchy', path: "/"
    @route 'edit', path: "/:class_name/edit"

MetaModel.ApplicationAdapter = DS.ActiveModelAdapter.extend()

MetaModel.ApplicationSerializer = DS.ActiveModelSerializer.extend()

MetaModel.FocusInputComponent = Ember.TextField.extend
  becomeFocused: (->
    @$().focus()
  ).on('didInsertElement')



MetaModel.Property = DS.Model.extend
  name: DS.attr 'string'
  type: DS.attr 'string'
  model: DS.belongsTo 'Model'

MetaModel.Model = DS.Model.extend
  class_name: DS.attr 'string'
  superclass_model: DS.belongsTo 'Model'
  #superclass_model: DS.attr 'string'
  properties: DS.hasMany 'Property'




MetaModel.MetaModelsHierarchyRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/meta/models/hierarchy.json').then (data) ->
      data.models
  actions:
    goto_metamodel: (model) ->
      console.log 'meta goto_metamodel'
      @transitionTo 'meta-models.edit', record


MetaModel.ModelsHierarchyRoute = MetaModel.MetaModelsHierarchyRoute.extend
  actions:
    goto_metamodel: (model) ->
      console.log 'normal goto_metamodel'
      @transitionTo 'models.index', record

MetaModel.MetaModelsHierarchyController = Ember.Controller.extend
  new_model_name: ''

  actions:
    add: (class_name) ->
     @store.createRecord('model', class_name: @new_model_name).save().then (record) =>
       @transitionToRoute 'meta-models.edit', record



MetaModel.MetaModelsEditRoute = Ember.Route.extend
  model: (params) ->
    Ember.RSVP.hash
      model: @store.find 'model', params.class_name
      models: @store.find 'model'
      property_types: ['String', 'DateTime']

  actions:
    add_property: (model) ->
      property = model.get('properties').createRecord name: '', type: 'String', model_id: model.id
      property.save()

    delete_property: (property) ->
      property.destroyRecord()

    save: (model) ->
      model.save() #if model.get 'isDirty'
      model.get('properties').forEach (property) ->
        property.save() if property.get 'isDirty'

    delete: (model) ->
      model.destroyRecord().then =>
       @transitionTo 'meta-models.hierarchy'
