#Include 'Protheus.ch'
/*/

Ponto de entrada na rotina de cadastro de produto

https://centraldeatendimento.totvs.com/hc/pt-br/articles/360000351188-Cross-Segmento-TOTVS-Backoffice-Linha-Protheus-ADVPL-Pontos-de-entrada-MVC-da-rotina-MATA010

@author CHARLES REITZ
@since 31/07/2023
/*/
User Function ITEM()
	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cMsg       := ''
	Local cClasse

	If aParam <> NIL
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		lIsGrid    := "GRID" $ oObj:ClassName()

		cClasse := oObj:ClassName()

		If lIsGrid
			nQtdLinhas := oObj:GetQtdLine()
			nLinha     := oObj:nLine
		EndIf

		If     cIdPonto ==  'MODELPOS'
			cMsg := 'Chamada na valida��o total do modelo (MODELPOS).' + CRLF
			cMsg += 'ID '  + cIdModel + CRLF
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O MODELPOS retornou .F.', 1, 0 )
			EndIf

		ElseIf cIdPonto ==  'FORMPOS'
			cMsg := 'Chamada na valida��o total do formul�rio (FORMPOS).' + CRLF
			cMsg += 'ID '  + cIdModel + CRLF
			If      cClasse == 'FWFORMGRID'
				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
					'     linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
			ElseIf cClasse == 'FWFORMFIELD'
				cMsg += '� um FORMFIELD' + CRLF
			EndIf
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMPOS retornou .F.', 1, 0 )

			EndIf

		ElseIf cIdPonto ==  'FORMLINEPRE'
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pr� valida��o da linha do formul�rio (FORMLINEPRE).' + CRLF
				cMsg += 'Onde esta se tentando deletar uma linha' + CRLF
				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) +;
					' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
				cMsg += 'ID '  + cIdModel + CRLF
				If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
					Help( ,, 'Help',, 'O FORMLINEPRE retornou .F.', 1, 0 )
				EndIf
			EndIf

		ElseIf cIdPonto ==  'FORMLINEPOS'
			cMsg := 'Chamada na valida��o da linha do formul�rio (FORMLINEPOS).' + CRLF
			cMsg += 'ID '  + cIdModel + CRLF
			cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ;
				' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha     ) ) + CRLF
			If !( xRet := ApMsgYesNo( cMsg + 'Continua ?' ) )
				Help( ,, 'Help',, 'O FORMLINEPOS retornou .F.', 1, 0 )
			EndIf

		ElseIf cIdPonto ==  'MODELCOMMITTTS'
			ApMsgInfo('Chamada apos a grava��o total do modelo e dentro da transa��o (MODELCOMMITTTS).' + CRLF + 'ID '  + cIdModel )

		ElseIf cIdPonto ==  'MODELCOMMITNTTS'
			ApMsgInfo('Chamada apos a grava��o total do modelo e fora da transa��o (MODELCOMMITNTTS).'  + CRLF + 'ID '  + cIdModel)

		ElseIf cIdPonto ==  'FORMCOMMITTTSPOS'
			ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio (FORMCOMMITTTSPOS).'  + CRLF + 'ID '  + cIdModel)

		ElseIf cIdPonto ==  'MODELCANCEL'
			cMsg := 'Chamada no Bot�o Cancelar (MODELCANCEL).' + CRLF + 'Deseja Realmente Sair ?'

			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELCANCEL retornou .F.', 1, 0 )
			EndIf

		ElseIf cIdPonto ==  'MODELVLDACTIVE'
			cMsg := 'Chamada na valida��o da ativa��o do Model.' + CRLF + ;
				'Continua ?'
			If !( xRet := ApMsgYesNo( cMsg ) )
				Help( ,, 'Help',, 'O MODELVLDACTIVE retornou .F.', 1, 0 )
			EndIf

		ElseIf cIdPonto ==  'BUTTONBAR'
			ApMsgInfo('Adicionando Bot�o na Barra de Bot�es (BUTTONBAR).' + CRLF + 'ID '  + cIdModel )
			xRet := { {'Salvar', 'SALVAR', { || Alert( 'Salvou' ) }, 'Este bot�o Salva' } }
		EndIf

	EndIf
Return xRet
