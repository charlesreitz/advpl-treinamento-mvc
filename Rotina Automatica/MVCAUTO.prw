
/*/

MVC Auto

@author CHARLES REITZ
@since 01/04/2022

/*/
User Function MVCAUTO()
	Local nOperacao := 3
	Local lReturn := .F.
	Local cMessage := ""

	Begin sequence

		oModel := FWLoadMOdel("MVC01")
		oModel:SetOperation(nOperacao)
		
		If !oModel:Activate()
			Break
		Endif

		oModelZ00 := oModel:GetModel("Z00MASTER")

		If !oModelZ00:SetValue("Z00_NOME","CHARLES REITZ")
			Break
		Endif

		If !oModel:VldData()
			Break
		Endif

		If !oModel:CommitData()
			Break
		EndIf

		If  oModelZ00 <> nil
			nId := oModelZ00:GetDataID()
			cId := oModelZ00:GetValue("Z00_ID")
		EndIf

		lReturn := .T.
	End Sequence

	IF !lReturn .AND. oModel <> nil

		IF !Empty(oModel:GetErrorMessage()[6])
			If !Empty(cMessage)
				cMessage += ' - '
			EndIf
			cMessage += cValToChar(oModel:GetErrorMessage()[6])
		Else
			If !Empty(oModel:GetErrorMessage()[4])
				If !Empty(cMessage)
					cMessage += ' - '
				EndIf
				cMessage += cValToChar(oModel:GetErrorMessage()[4])
			ENdIf
			IF !Empty(oModel:GetErrorMessage()[5])
				If !Empty(cMessage)
					cMessage += ' - '
				EndIf
				cMessage += cValToChar(oModel:GetErrorMessage()[5])
			EndIf
		ENdif

		FWalerterror(cMessage,"Atenção - "+ProcName()+cValToChar(ProcLine()))
	EndIf

	If oModel <> nil
		oModel:DeActivate()
	EndIf
	oModel := nil
	FreeObj(oModel)

	// FWalerterror("Erro ao gravar registro "+cMessage,"Atenção - "+ProcName()+cValToChar(ProcLine()))
Return lReturn
