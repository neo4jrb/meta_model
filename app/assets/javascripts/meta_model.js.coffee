#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./components
#= require_tree ./templates
#= require_tree ./routes
#= require ./router
#= require_self


# for more details see: http://emberjs.com/guides/application/
window.MetaModel = Ember.Application.create(rootElement: '#ember-application')

MetaModel.ApplicationController = Ember.Controller.extend()

MetaModel.Model = DS.Model.extend()

MetaModel.MetaModelAdapter = DS.RESTAdapter.extend
  namespace: 'meta'

MetaModel.ModelAdapter = MetaModel.MetaModelAdapter.extend()
MetaModel.PropertyAdapter = MetaModel.MetaModelAdapter.extend()
MetaModel.HasAssociationAdapter = MetaModel.MetaModelAdapter.extend()


MetaModel.Router.map ->
  @route 'index', path: "/"

  @resource 'models', path: '/models', ->
    @route 'hierarchy', path: "/"
    @route 'edit', path: "/:class_name/edit"

  @resource 'associations', path: 'associations', ->
    @route 'index', path: '/'



MetaModel.ApplicationAdapter = DS.ActiveModelAdapter.extend()

MetaModel.ApplicationSerializer = DS.ActiveModelSerializer.extend()

# Components

MetaModel.FocusInputComponent = Ember.TextField.extend
  becomeFocused: (->
    @$().focus()
  ).on('didInsertElement')



MetaModel.ModelListItemComponent = Ember.Component.extend
  action: 'meta_model_clicked'
  actions:
    clicked: ->
      @sendAction 'action', @get('model')

MetaModel.ModelListComponent = Ember.Component.extend
  action: 'goto_metamodel'
  actions:
    meta_model_clicked: (model) ->
      @sendAction 'action', model


# Models

MetaModel.Property = DS.Model.extend
  name: DS.attr 'string'
  type: DS.attr 'string'
  model: DS.belongsTo 'Model', inverse: 'properties'

MetaModel.Model = DS.Model.extend
  class_name: DS.attr 'string'
  superclass_model: DS.belongsTo 'Model'
  #superclass_model: DS.attr 'string'
  properties: DS.hasMany 'Property'
  has_associations: DS.hasMany 'Property'

MetaModel.HasAssociation = DS.Model.extend
  join_type: DS.attr 'string'
  name: DS.attr 'string'
  opposite_name: DS.attr 'string'
  relationship_type: DS.attr 'string'
  model: DS.belongsTo 'Model', inverse: 'has_associations'

# Routes / Controllers


MetaModel.ModelsHierarchyRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON('/meta/models/hierarchy.json').then (data) ->
      data.models
  actions:
    goto_metamodel: (model) ->
      @transitionTo 'models.edit', model


MetaModel.ModelsHierarchyController = Ember.Controller.extend
  new_model_name: ''

  actions:
    add: (class_name) ->
     @store.createRecord('model', class_name: @new_model_name).save().then (record) =>
       @transitionToRoute 'models.edit', record



MetaModel.ModelsEditRoute = Ember.Route.extend
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
       @transitionTo 'models.hierarchy'

