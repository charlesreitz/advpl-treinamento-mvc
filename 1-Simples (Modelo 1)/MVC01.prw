#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function MVC01()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('Z00')
	oBrowse:SetDescription('Cadastro de Usuários')
	oBrowse:AddLegend( "Z00_ADM", "GREEN", "Administrador" )
	oBrowse:AddLegend( "!Z00_ADM", "YELLOW", "Usuário" )
	oBrowse:SetMenuDef( 'MVC01' )

	// If __cUserID != '000000'
	// 	oBrowse:SetFilterDefault( "!Z00_ADM" )
	// EndIF
	oBrowse:Activate()

Return

Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC01' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC01' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC01' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC01' OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Auto Incluir'     ACTION 'U_MVCAUTO()' OPERATION 2 ACCESS 0

Return aRotina
Static Function ModelDef()
	Local oModel
	Local oStruZ00 := FWFormStruct(1,"Z00")

	// oStruZ00:RemoveField( 'Z00_OBS' )
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_TITULO, "COISA LINDA ")
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_OBRIGAT, .T.)
	// oStruZ00:SetProperty("Z00_OBS"		, MODEL_FIELD_WHEN, .T.)


	oModel := MPFormModel():New("U_MVC01",{|a,b,c| preValid(a,b,c) }/*bPreValidacao*/,;
		{|a,b,c| posValid(a,b,c) }/*bPosValidacao*/,;
		{|oModel| comModel(oModel) }/*bCommit*/,;
		{|a,b,c| canModel(a,b,c) }/*bCancel*/ )

	oModel:SetDescription("Cadastro de Usuários")

	oModel:addFields('Z00MASTER', /*cOwner*/, oStruZ00)
	// oModel:addFields('Z00MASTER', /*cOwner*/, oStruZ00,;
		// 	{|a,b,c| preVZ00(a,b,c) }/*bPreValidacao*/,;
		// 	{|a,b,c| posVZ00(a,b,c) }/*bPosValidacao*/)
	oModel:getModel('Z00MASTER'):SetDescription('Cadastro de Usuários master')
	oModel:getModel('Z00MASTER'):SetPrimaryKey( { "Z00_FILIAL", "Z00_ID" } )
	oModel:SetVldActivate({|oModel| valModel(oModel) } )

Return oModel
Static Function ViewDef()
	Local oModel := ModelDef() //fWLoadMOdel("MVC01")
	Local oView
	Local oStrZ00:= FWFormStruct(2, 'Z00')

	// oStrZ00:SetProperty( '*' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_Z00' , oStrZ00,'Z00MASTER' )
	oView:CreateHorizontalBox( 'BOX_FORM_Z00', 100)
	oView:SetOwnerView('FORM_Z00','BOX_FORM_Z00')

Return oView
Static Function valModel(oModel,b,c)
return .t.
Static Function preValid(oModel,b,c)
Return .T.
Static Function posValid(oModel,b,c)
Return .T.
Static Function posVZ00(oModel,b,c)
	Local lBlind := IsBlind()

	// alert('Preço unitário não informado.')
	if !lBlind .AND. FWAlertYesNo("Sai fora","Atenção - "+ProcName()+cValToChar(ProcLine()))
		//Help( ,, 'Help',, 'Preço unitário não informado.', 1, 0 )
		oModel:GetModel():SetErrorMessage(oModel:GetId(),"",oModel:GetId(),"",ProcName(),"Teste" )
		Return .F.
	eNDIF

Return .T.
Static Function comModel(oModel)
	Local lRetTranok := .T.

	BEGIN TRANSACTION

		//INSERT EM OUTRA TRABELA
		//IF NAO FOI FOI FEITO
		//	ROLLBACK
		//  BREAK
		//END

		lRetTranok := FwFormCommit( oModel )

		iF !lRetTranok
			DISARMTRANSACTION()
			Break
		EndIf


	END TRANSACTION

Return lRetTranok
Static Function canModel(a,b,c)
Return .t.

Static Function preVZ00(a,b,c)
Return .T.

