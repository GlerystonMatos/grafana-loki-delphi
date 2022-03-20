object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'GrafanaLokiDelphi'
  ClientHeight = 504
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbEnderecoLoki: TLabel
    Left = 16
    Top = 16
    Width = 70
    Height = 13
    Caption = 'Endere'#231'o Loki:'
  end
  object lbNomeAplicacao: TLabel
    Left = 16
    Top = 43
    Width = 79
    Height = 13
    Caption = 'Nome Aplica'#231#227'o:'
  end
  object lbTexto: TLabel
    Left = 16
    Top = 121
    Width = 32
    Height = 13
    Caption = 'Texto:'
  end
  object lbQuantidade: TLabel
    Left = 16
    Top = 452
    Width = 60
    Height = 13
    Caption = 'Quantidade:'
  end
  object lbUsuario: TLabel
    Left = 16
    Top = 70
    Width = 40
    Height = 13
    Caption = 'Usu'#225'rio:'
  end
  object lbSenha: TLabel
    Left = 16
    Top = 97
    Width = 34
    Height = 13
    Caption = 'Senha:'
  end
  object detEnderecoLoki: TEdit
    Left = 92
    Top = 13
    Width = 299
    Height = 21
    TabOrder = 0
    Text = 'http://localhost:80/'
  end
  object detNomeAplicacao: TEdit
    Left = 98
    Top = 40
    Width = 293
    Height = 21
    TabOrder = 1
    Text = 'grafana-loki-delphi'
  end
  object mLog: TMemo
    Left = 16
    Top = 140
    Width = 375
    Height = 303
    Lines.Strings = (
      'log teste grafana-loki-delphi 0')
    TabOrder = 4
  end
  object detQuantidade: TEdit
    Left = 81
    Top = 449
    Width = 65
    Height = 21
    TabOrder = 5
    Text = '10'
  end
  object btnEnviar: TButton
    Left = 151
    Top = 447
    Width = 240
    Height = 25
    Caption = 'Enviar'
    TabOrder = 6
    OnClick = btnEnviarClick
  end
  object pbProgress: TProgressBar
    Left = 16
    Top = 476
    Width = 375
    Height = 17
    TabOrder = 7
  end
  object detUsuario: TEdit
    Left = 62
    Top = 67
    Width = 329
    Height = 21
    TabOrder = 2
    Text = 'glerystonmatos'
  end
  object detSenha: TEdit
    Left = 54
    Top = 94
    Width = 337
    Height = 21
    TabOrder = 3
    Text = '123@456'
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Params = <>
    Left = 306
    Top = 154
  end
  object RESTRequest: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Kind = pkREQUESTBODY
        Name = 'body34B8FFD02808482C90FD8051A08AC56F'
        Value = 
          '{'#13#10'    "streams": ['#13#10'        {'#13#10'            "stream": {'#13#10'       ' +
          '         "job": "postman"'#13#10'            },'#13#10'            "values":' +
          ' ['#13#10'                ['#13#10'                    "{{unix_epoch_in_nano' +
          'seconds}}",'#13#10'                    "mensagem=\"log teste postman 0' +
          '1\""'#13#10'                ]'#13#10'            ]'#13#10'        }'#13#10'    ]'#13#10'}'
        ContentType = ctAPPLICATION_JSON
      end>
    Response = RESTResponse
    Left = 307
    Top = 204
  end
  object RESTResponse: TRESTResponse
    Left = 307
    Top = 258
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Left = 306
    Top = 310
  end
end
