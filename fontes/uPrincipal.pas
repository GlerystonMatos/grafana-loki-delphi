unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.DateUtils, Vcl.ComCtrls, REST.Authenticator.Basic;

type
  TfrmPrincipal = class(TForm)
    mLog: TMemo;
    lbTexto: TLabel;
    btnEnviar: TButton;
    lbQuantidade: TLabel;
    detQuantidade: TEdit;
    lbEnderecoLoki: TLabel;
    detEnderecoLoki: TEdit;
    detNomeAplicacao: TEdit;
    lbNomeAplicacao: TLabel;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    pbProgress: TProgressBar;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    lbUsuario: TLabel;
    detUsuario: TEdit;
    lbSenha: TLabel;
    detSenha: TEdit;
    procedure btnEnviarClick(Sender: TObject);
  private
    function GetJsonLog(): string;
    function DateTimeToUNIXTime(DateTime : TDateTime): string;
    function PreencheZeroDireita(Texto: string; Quantidade: Integer): string;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  index: Integer;
begin
  HTTPBasicAuthenticator.Username := Trim(detUsuario.Text);
  HTTPBasicAuthenticator.Password := Trim(detSenha.Text);

  RESTClient.BaseURL := Trim(detEnderecoLoki.Text) + 'loki/api/v1/push';
  RESTClient.Authenticator := HTTPBasicAuthenticator;

  RESTRequest.Method := rmPOST;
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.AcceptCharset := 'utf-8, *;q=0.8';
  RESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';

  pbProgress.Min := 0;
  pbProgress.Position := 0;
  pbProgress.Max := StrToInt(Trim(detQuantidade.Text));

  for index := 0 to Pred(pbProgress.Max) do
  begin
    RESTRequest.Params[0].Value := GetJsonLog();
    RESTRequest.Execute;

    if (RESTResponse.StatusCode <> 204) then
    begin
      Break;
      ShowMessage('Status Code: ' + IntToStr(RESTResponse.StatusCode) + #13 +
        'Status Text: ' + RESTResponse.StatusText);
    end;

    Sleep(1000);
    pbProgress.Position := pbProgress.Position + 1;
  end;

  ShowMessage('Envio realizado com sucesso.');
end;

function TfrmPrincipal.DateTimeToUNIXTime(DateTime : TDateTime): string;
begin
  Result := PreencheZeroDireita(IntToStr(DateTimeToUnix(DateTime, False)), 19);
end;

function TfrmPrincipal.PreencheZeroDireita(Texto: string; Quantidade: Integer): string;
begin
  Result := Texto;
  Quantidade := Quantidade - Length(Result);
  if (Quantidade > 0) then
     Result := Result + StringOfChar('0', Quantidade);
end;

function TfrmPrincipal.GetJsonLog(): string;
begin
  Result :=
    '{' +
    '    "streams": [' +
    '        {' +
    '            "stream": {' +
    '                "job": "' + Trim(detNomeAplicacao.Text) + '"' +
    '            },' +
    '            "values": [' +
    '                [' +
    '                    "' + DateTimeToUNIXTime(Now()) + '",' +
    '                    "mensagem=\"' + Trim(mLog.Lines.Text) + '\""' +
    '                ]' +
    '            ]' +
    '        }' +
    '    ]' +
    '}'
end;

end.
