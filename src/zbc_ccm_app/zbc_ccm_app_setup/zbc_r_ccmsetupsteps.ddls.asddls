@EndUserText.label: 'Setup Steps'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BC_CCM_SETUP_QUERY'
@UI.headerInfo.typeName: 'Step'
@UI.headerInfo.typeNamePlural: 'Steps'
define root custom entity ZBC_R_CCMSetupSteps
{
      @UI.lineItem      : [
        { position      : 10, criticality: 'StatusCriticality' },
        { position      : 30, type: #FOR_ACTION, label: 'Check', dataAction: 'CheckStep', inline: true },
        { position      : 40, type: #FOR_ACTION, label: 'Execute', dataAction: 'ExecuteStep', inline: true }
//        { position      : 50, type: #FOR_INTENT_BASED_NAVIGATION, label: 'Navigate', inline: true, semanticObject: #(NavigationObject), semanticObjectAction: #(NavigationAction) }
      ]
      @ObjectModel.text.element: [ 'StepDescription' ]
      @UI.textArrangement:#TEXT_ONLY
      @Consumption.filter.hidden: true
      @EndUserText.label: 'Step'
  key StepID            : abap.char(2);

      @UI.hidden        : true
      @EndUserText.label: 'Description'
      StepDescription   : abap.sstring(60);

      @UI.hidden        : true
      @EndUserText.label: 'Criticality'
      StatusCriticality : abap.int1;

      @UI.lineItem      : [{ position: 20 }]
      @Consumption.filter.hidden: true
      @EndUserText.label: 'Status'
      StatusMessage     : abap.sstring(250);

      @Consumption.filter.hidden: true
      NavigationObject  : abap.sstring(200);
      
      @Consumption.filter.hidden: true      
      NavigationAction  : abap.sstring(50);
}
