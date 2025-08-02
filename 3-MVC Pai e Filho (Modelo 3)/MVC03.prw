#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'


//Modelo 3 (2 Tabelas diferentes cabeçalho/ítens)
User Function MVC03()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z01')
	oBrowse:SetDescription('Cadastro de Usuários e Observacoes')
	// oBrowse:AddLegend( "Z01_ADM", "GREEN", "Administrador" )
	// oBrowse:AddLegend( "!Z01_ADM", "YELLOW", "Usuário" )
	oBrowse:SetMenuDef( 'MVC03' )
	oBrowse:Activate()

Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC03' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC03' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC03' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC03' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC03' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC03' OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Auto Incluir'     ACTION 'U_MVCAUTO()' OPERATION 2 ACCESS 0

Return aRotina
Static Function ModelDef()
	Local oModel
	Local oStruZ01 := FWFormStruct(1,"Z01")
	Local oStruZ02 := FWFormStruct(1,"Z02")

	// oStruZ01:RemoveField( 'Z01_OBS' )
	// oStruZ01:SetProperty("Z01_OBS"		, MODEL_FIELD_TITULO, "COISA LINDA ")
	// oStruZ01:SetProperty("Z01_OBS"		, MODEL_FIELD_OBRIGAT, .T.)
	// oStruZ01:SetProperty("Z01_OBS"		, MODEL_FIELD_WHEN, .T.)

	// oStruZ01:AddField( ;                      // Ord. Tipo Desc.
	// "Valor Alimentação"        , ;      // [01]  C   Titulo do campo
	// "Valor da despesa de alimentação para integrar com o gestão de despesa"     , ;      // [02]  C   ToolTip do campo
	// 'DVAL_ALIME'                     , ;      // [03]  C   Id do Field
	// "N"                             , ;      // [04]  C   Tipo do campo
	// 10                                , ;      // [05]  N   Tamanho do campo
	// 2                                , ;      // [06]  N   Decimal do campo
	// {|| .T.  }                            , ;      // [07]  B   Code-block de validação do campo
	// {|| IB2ValCabI() }                            , ;      // [08]  B   Code-block de validação When do campo
	// NIL                              , ;      // [09]  A   Lista de valores permitido do campo
	// .F.                              , ;      // [10]  L   Indica se o campo tem preenchimento obrigatório
	// NIL, ;   // [11]  B   Code-block de inicializacao do campo
	// NIL                              , ;      // [12]  L   Indica se trata-se de um campo chave
	// NIL                              , ;      // [13]  L   Indica se o campo pode receber valor em uma operação de update.
	// .T.                              )        // [14]  L   Indica se o campo é virtual

	oModel := MPFormModel():New("MVC03_MASTER")

	oModel:SetDescription("Cadastro de Usuários")

	oModel:addFields('Z01MASTER', /*cOwner*/, oStruZ01)
	oModel:getModel('Z01MASTER'):SetDescription('Cadastro de Usuários master')
	oModel:getModel('Z01MASTER'):SetPrimaryKey( { "Z01_FILIAL", "Z01_ID" } )
	oModel:AddGrid( 'Z02DETAILS','Z01MASTER', oStruZ02)


	oModel:SetRelation("Z02DETAILS", {{"Z02_FILIAL", "FwXFilial('Z02')"}, {"Z02_IDZ01", "Z01_ID"}}, Z02->(IndexKey( 1 )))
	oModel:GetModel( 'Z02DETAILS' ):SetDescription( 'Observacoes do usuario ' )
	// oModel:GetModel('Z02DETAILS'):SetOptional(.T.)

	// oModel:GetModel("Z02DETAILS"):SetOnlyQuery(.T.)
	// // oModel:GetModel("Z02DETAILS"):SetOnlyView(.T.)
	// // oModel:GetModel("Z02DETAILS"):SetNoUpdateLine(.T.)
	// oModel:GetModel("Z02DETAILS"):SetNoInsertLine(.T.)
	// oModel:GetModel("Z02DETAILS"):SetNoDeleteLine(.T.)

Return oModel
Static Function ViewDef()
	Local oModel := ModelDef() //fWLoadMOdel("MVC03")
	Local oView
	Local oStrZ01:= FWFormStruct(2, 'Z01')
	Local oStrZ02:= FWFormStruct(2, 'Z02')

	// oStrZ01:SetProperty( '*' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_Z01' , oStrZ01,'Z01MASTER' )
	oView:AddGrid(  'GRID_Z02', oStrZ02, 'Z02DETAILS' )

	// oView:SetNoDeleteLine('VIEW_IB1')
	// oView:CanDeleteLine('VIEW_IB1')
	// oView:SetNoInsertLine('VIEW_IB1')
	// oView:CanUpdateLine('VIEW_IB1')

	oView:AddIncrementField('GRID_Z02', 'Z02_SEQ')

	oView:CreateHorizontalBox( 'SUPERIOR'   , 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )

	oView:SetOwnerView('FORM_Z01','SUPERIOR')
	oView:SetOwnerView('GRID_Z02','INFERIOR')
Return oView
