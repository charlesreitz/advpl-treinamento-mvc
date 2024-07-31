#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc}  MVC02

@type function MVC02
@author TSC679 - CHARLES REITZ
@since 30/09/2019
/*/
User Function MVC02()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZM0')
	oBrowse:AddLegend( "ZM0_MSBLQL == '2' ", "GREEN", "Ativo"       )
	oBrowse:AddLegend( "ZM0_MSBLQL == '1' ", "RED", "Inativo"       )
	oBrowse:SetDescription('Usuários X Região - Adicional')
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef

Menus

@type function
@author TSC679 - CHARLES REITZ
@since 30/09/2019
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC02' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC02' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC02' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC02' OPERATION 8 ACCESS 0
Return aRotina


/*/{Protheus.doc} MOdelDef

Modelo

@type function
@author TSC679 - CHARLES REITZ
@since 19/02/2016
@version 1.0
/*/
Static Function ModelDef()
	Local oStruZM0 	:= FWFormStruct( 1, 'ZM0',{|cCampo| (AllTRim(cCampo) $ "ZM0_FILIAL|ZM0_CODUSR")},/*lViewUsado*/ )
	Local oStruZM0F := FWFormStruct( 1, 'ZM0',{|cCampo| !(AllTRim(cCampo) $ "ZM0_FILIAL|ZM0_CODUSR") }/*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	oModel := MPFormModel():New('KRAA012M', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
	oModel:AddFields( 'ZM0MASTER', /*cOwner*/, oStruZM0, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ZM0DETAILS','ZM0MASTER', oStruZM0F, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	//oModel:SetDescription( 'Cadastro de Grupo de Produtos X Natureza X Conta Contabil X Tipo ' )
	//oModel:GetModel( 'ZM0MASTER' ):SetDescription( 'Cadastro de Grupo de Produtos X Pessoa X Natureza Fiscal' )
	oModel:SetRelation("ZM0DETAILS",{{"ZM0_FILIAL",'fwxFilial("ZM0")'},{"ZM0_CODUSR","ZM0_CODUSR"}},ZM0->(IndexKey(1)))
	oModel:GetModel( 'ZM0DETAILS' ):SetUniqueLine( {'ZM0_REGIAO'} )
	oModel:GetModel( 'ZM0DETAILS' ):SetDelAllLine(.T.)
	oModel:SetPrimaryKey({'ZM0_FILIAL','ZM0_CODUSR','ZM0_REGIAO'})
	
Return oModel


/*/{Protheus.doc} ViewDef

ViewDef

@type function
@author TSC679 - CHARLES REITZ
@since 19/02/2016
@version 1.0
/*/
Static Function ViewDef()
	Local oModel     := ModelDef()
	Local oStructZM0 := FWFormStruct( 2, 'ZM0' ,{|cCampo| (AllTRim(cCampo) $ "ZM0_FILIAL|ZM0_CODUSR")})
	Local oStructGrid := FWFormStruct( 2, 'ZM0', {|cCampo| !(AllTRim(cCampo) $ "ZM0_FILIAL|ZM0_CODUSR") } /*, { |cCampo| camposSG2(cCampo) }*/ )

	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZM0', oStructZM0, 'ZM0MASTER' )
	oView:AddGrid(  'VIEW_GRIDZM0', oStructGrid, 'ZM0DETAILS' )

	oView:CreateHorizontalBox( 'SUPERIOR', 10 )
	oView:CreateHorizontalBox( 'INFERIOR', 90 )

	oView:SetOwnerView( 'VIEW_ZM0', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_GRIDZM0', 'INFERIOR' )

Return oView
