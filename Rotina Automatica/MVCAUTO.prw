
/*/

MVC Auto

@author CHARLES REITZ
@since 01/04/2022

/*/
User Function MVCAUTO()
	Local nOperacao := 3
	Local lReturn := .F. 

	Begin sequence

		oModel := FWLoadMOdel("MVC03")
		oModel:SetOperation(nOperacao)
		oModel:Activate()
		oModelIB2 := oModel:GetModel("IB2MASTER")
		oModelIB1 := oModel:GetModel("IB1DETAILS")

		nTotApt := Len(oJson['apontamentos'])

		If nTotApt == 0
			cMessage := "Não foi enviado apontamos para geração da ordemd e serviço"
			Break
		EndIf

		// Define para não calcular a cada mark da IB1, vai calcular SCA, Z02, somente no TUDO OK, ganha performance e menos processamento
		If !oModelIB2:LoadValue("CALCULA",.F.)
			Break
		EndIf

		If !oModelIB2:SetValue("IB2_CLI",Left(oJson['cliente'],nIAXCLI))
			Break
		EndIf

		If oModelIB1:Length() == 0
			cMessage := "Nenhum apontamento localizado para vincular a ordem de serviço"
			Break
		EndIf

		// Marca os registros que deve gerar ordem de caserviço, com base no carregamento do modelo de dados
		For nI := 1 To nTotApt
			For nIB := 1 To oModelIB1:Length()
				oModelIB1:GoLine(nIB)
				If oJson['apontamentos'][nI] == oModelIB1:GetValue("RECNOIB1")
					oModelIB1:SetValue("MARK",.T.)
				Endif
			Next
		Next



		If !oModel:VldData()
			Break
		Endif
		If !oModel:CommitData()
			Break
		EndIf

		If  oModelIB2 <> nil
			nId := oModelIB2:GetDataID()
			cNumeroOS := oModelIB2:GetValue("IB2_NUMOS")
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
	EndIf

	If oModel <> nil
		oModel:DeActivate()
	EndIf
Return lReturn
