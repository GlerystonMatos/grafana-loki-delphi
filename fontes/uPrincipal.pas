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
    lbSenha: TLabel;
    detSenha: TEdit;
    mResposta: TMemo;
    lbUsuario: TLabel;
    detUsuario: TEdit;
    lbResposta: TLabel;
    btnEnviar: TButton;
    lbQuantidade: TLabel;
    detQuantidade: TEdit;
    lbEnderecoLoki: TLabel;
    detEnderecoLoki: TEdit;
    detNomeAplicacao: TEdit;
    lbNomeAplicacao: TLabel;
    pbProgress: TProgressBar;
    procedure btnEnviarClick(Sender: TObject);
  private
    function GetJsonLog(): string;
    function DateTimeToUNIXTime(ADateTime : TDateTime): string;
    function PreencheZeroDireita(ATexto: string; AQuantidade: Integer): string;
    procedure EnviarLog;
    procedure EscreverResposta(var ARESTResponse: TRESTResponse);
    procedure ConfigurarHTTPBasicAuthenticator(var AHTTPBasicAuthenticator: THTTPBasicAuthenticator);
    procedure ConfigurarRESTClient(var ARESTClient: TRESTClient; var AHTTPBasicAuthenticator: THTTPBasicAuthenticator);
    procedure ConfigurarRESTRequest(var ARESTRequest: TRESTRequest; var ARESTClient: TRESTClient; var ARESTResponse: TRESTResponse);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  Index: Integer;
begin
  pbProgress.Min := 0;
  pbProgress.Position := 0;
  pbProgress.Max := StrToInt(Trim(detQuantidade.Text));

  mResposta.Lines.Clear;
  for Index := 0 to Pred(pbProgress.Max) do
  begin
    EnviarLog;
    Sleep(1000);
  end;
end;

procedure TfrmPrincipal.EnviarLog;
begin
  TThread.CreateAnonymousThread(
  procedure
  var
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
  begin
    HTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);
    try
      ConfigurarHTTPBasicAuthenticator(HTTPBasicAuthenticator);
      RESTClient := TRESTClient.Create(nil);
      try
        ConfigurarRESTClient(RESTClient, HTTPBasicAuthenticator);
        RESTResponse := TRESTResponse.Create(nil);
        try
          RESTRequest := TRESTRequest.Create(nil);
          try
            ConfigurarRESTRequest(RESTRequest, RESTClient, RESTResponse);
            RESTRequest.Params[0].Value := GetJsonLog();
            RESTRequest.Execute;

            TThread.Sleep(1000);
            TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              EscreverResposta(RESTResponse);
              pbProgress.Position := pbProgress.Position + 1;
            end);
          finally
            RESTRequest.Free;
          end;
        finally
          RESTResponse.Free;
        end;
      finally
        RESTClient.Free;
      end;
    finally
      HTTPBasicAuthenticator.Free;
    end;
  end).Start;
end;

procedure TfrmPrincipal.ConfigurarHTTPBasicAuthenticator(var AHTTPBasicAuthenticator: THTTPBasicAuthenticator);
begin
  AHTTPBasicAuthenticator.Username := Trim(detUsuario.Text);
  AHTTPBasicAuthenticator.Password := Trim(detSenha.Text);
end;

procedure TfrmPrincipal.ConfigurarRESTClient(var ARESTClient: TRESTClient; var AHTTPBasicAuthenticator: THTTPBasicAuthenticator);
begin
  ARESTClient.BaseURL := Trim(detEnderecoLoki.Text) + 'loki/api/v1/push';
  ARESTClient.Authenticator := AHTTPBasicAuthenticator;
end;

procedure TfrmPrincipal.ConfigurarRESTRequest(var ARESTRequest: TRESTRequest; var ARESTClient: TRESTClient; var ARESTResponse: TRESTResponse);
begin
  ARESTRequest.Method := rmPOST;
  ARESTRequest.Client := ARESTClient;
  ARESTRequest.Response := ARESTResponse;
  ARESTRequest.AcceptCharset := 'utf-8, *;q=0.8';
  ARESTRequest.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';

  ARESTRequest.Params.AddItem.AddValue('');
  ARESTRequest.Params[0].Kind := pkREQUESTBODY;
  ARESTRequest.Params[0].ContentType := ctAPPLICATION_JSON;
end;

procedure TfrmPrincipal.EscreverResposta(var ARESTResponse: TRESTResponse);
begin
  mResposta.Lines.Add('Status Code: ' + IntToStr(ARESTResponse.StatusCode) + ', Status Text: ' + ARESTResponse.StatusText);
end;

function TfrmPrincipal.GetJsonLog(): string;
var
  DateTime: string;
begin
  DateTime := DateTimeToUNIXTime(Now());
  Result :=
    '{' +
    '    "streams": [' +
    '        {' +
    '            "stream": {' +
    '                "job": "' + Trim(detNomeAplicacao.Text) + '"' +
    '            },' +
    '            "values": [' +
    '                [' +
    '                    "' + DateTime + '",' +
    '                    "mensagem=\"' + Trim(mLog.Lines.Text) + '\""' +
    '                ]' +
    '            ]' +
    '        }' +
    '    ]' +
    '}'
end;

function TfrmPrincipal.DateTimeToUNIXTime(ADateTime : TDateTime): string;
begin
  Result := PreencheZeroDireita(IntToStr(DateTimeToUnix(ADateTime, False)), 19);
end;

function TfrmPrincipal.PreencheZeroDireita(ATexto: string; AQuantidade: Integer): string;
begin
  Result := ATexto;
  AQuantidade := AQuantidade - Length(Result);
  if (AQuantidade > 0) then
     Result := Result + StringOfChar('0', AQuantidade);
end;

end.
