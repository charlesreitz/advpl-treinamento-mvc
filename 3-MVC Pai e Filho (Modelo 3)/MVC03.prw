#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function MVC03()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z00')
	oBrowse:SetDescription('Cadastro de Usuários e Observacoes')
	oBrowse:AddLegend( "Z00_ADM", "GREEN", "Administrador" )
	oBrowse:AddLegend( "!Z00_ADM", "YELLOW", "Usuário" )
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
	Local oStruZ00 := FWFormStruct(1,"Z00")
	Local oStruZ01 := FWFormStruct(1,"Z01")

	// oStruZ00:RemoveField( 'Z00_OBS' )
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_TITULO, "COISA LINDA ")
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_OBRIGAT, .T.)
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_WHEN, .T.)

	// oStruZ00:AddField( ;                      // Ord. Tipo Desc.
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

	oModel := FWFormModel():New("U_MVC03" )

	oModel:SetDescription("Cadastro de Usuários")

	oModel:addFields('Z00MASTER', /*cOwner*/, oStruZ00)
	oModel:getModel('Z00MASTER'):SetDescription('Cadastro de Usuários master')
	oModel:getModel('Z00MASTER'):SetPrimaryKey( { "Z00_FILIAL", "Z00_ID" } )

	oModel:AddGrid( 'Z01DETAILS','Z00MASTER', oStruZ01)
	oModel:GetModel( 'Z01DETAILS' ):SetDescription( 'Observacoes do usuario ' )

	aReal := {}
	aadd(aReal, {"Z01_FILIAL","Z00_FILIAL"})
	aadd(aReal, {"Z01_IDZ00","Z00_ID"})

	oModel:SetRelation("Z01DETAILS",aReal,Z01->(IndexKey(1)))
	// oModel:GetModel("Z01DETAILS"):SetOnlyQuery(.T.)
	// // oModel:GetModel("Z01DETAILS"):SetOnlyView(.T.)
	// // oModel:GetModel("Z01DETAILS"):SetNoUpdateLine(.T.)
	// oModel:GetModel("Z01DETAILS"):SetNoInsertLine(.T.)
	// oModel:GetModel("Z01DETAILS"):SetNoDeleteLine(.T.)
	oModel:GetModel('Z01DETAILS'):SetOptional(.T.)



Return oModel
Static Function ViewDef()
	Local oModel := ModelDef() //fWLoadMOdel("MVC03")
	Local oView
	Local oStrZ00:= FWFormStruct(2, 'Z00')
	Local oStrZ01:= FWFormStruct(2, 'Z01')

	// oStrZ00:SetProperty( '*' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_Z00' , oStrZ00,'Z00MASTER' )
	oView:AddGrid(  'GRID_Z01', oStrZ01, 'Z01DETAILS' )

	// oView:SetNoDeleteLine('VIEW_IB1')
	// oView:CanDeleteLine('VIEW_IB1')
	// oView:SetNoInsertLine('VIEW_IB1')
	// oView:CanUpdateLine('VIEW_IB1')

	oView:CreateHorizontalBox( 'SUPERIOR'   , 40 )
	oView:CreateHorizontalBox( 'INFERIOR', 60 )

	oView:SetOwnerView('FORM_Z00','SUPERIOR')
	oView:SetOwnerView('GRID_Z01','INFERIOR')
Return oView
