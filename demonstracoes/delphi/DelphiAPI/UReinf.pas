unit UReinf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  WinHttp_TLB, superobject, Winapi.ShellAPI;

type
  TfReinf = class(TForm)
    lblAmbiente: TLabel;
    lbl2: TLabel;
    edtCnpjSH: TLabeledEdit;
    edtTokenSH: TLabeledEdit;
    edtEmpregador: TLabeledEdit;
    cbbAmbiente: TComboBox;
    cbbVersao: TComboBox;
    mmoXml: TMemo;
    edtIdLote: TLabeledEdit;
    btnEnviar: TButton;
    btnConsultar: TButton;
    btnGeraTx2: TButton;
    lbl1: TLabel;
    lnklbl1: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnGeraTx2Click(Sender: TObject);
  private
    { Private declarations }
    _http: IWinHttpRequest;
  public
    { Public declarations }
  end;

var
  fReinf: TfReinf;

implementation

{$R *.dfm}

procedure TfReinf.btnConsultarClick(Sender: TObject);
var
  url: string;
  obj, objEvento, objEventoOcor: ISuperObject;
begin
  if edtIdLote.Text = '' then
    ShowMessage('Informe um identificador de lote!')
  else
  begin
//  url := 'https://api.tecnospeed.com.br/reinf/v1/evento/consultar/' + edtIdLote.Text + '?ambiente=' + IntToStr(cbbAmbiente.ItemIndex + 1) + '&versaomanual=' + cbbVersao.Text;
    url := 'https://api.tecnospeed.com.br/reinf/v1/evento/consultar/' + edtIdLote.Text + '?ambiente=' + IntToStr(cbbAmbiente.ItemIndex + 1) + '&versaomanual=2';
    try
      mmoXml.Text := 'Realizando consulta do evento!';
      _http := CoWinHttpRequest.Create;
      _http.Open('GET', url, False);
      _http.SetRequestHeader('cnpj_sh', edtCnpjSH.Text);
      _http.SetRequestHeader('token_sh', edtTokenSH.Text);
      _http.Send('');
      obj := SO(_http.ResponseText);
      if obj.AsString = '' then
        ShowMessage('Verifique seu identificador do lote')
      else if obj.S['error'] <> '' then
      begin
        mmoXml.Clear;
        mmoXml.Text := 'Erro';
        mmoXml.Text := mmoXml.Text + #13#10 + ' Erro ao Enviar evento: ' + obj.S['error.message'];
      end
      else if obj.I['data.status_envio.codigo'] = 1 then
      begin
        mmoXml.Clear;
        mmoXml.Text := 'Mensagem: ' + obj.S['message'];
        mmoXml.Text := mmoXml.Text + #13#10 + ' Erro ao Enviar evento: ' + obj.S['data.status_envio.mensagem'];
      end
      else
      begin
        while (obj.S['data.status_consulta.mensagem'] = '') or (obj.S['data.status_consulta.mensagem'] = 'EMPROCESSAMENTO') do
        begin
          Sleep(1000);
          _http.Send('');
          obj := SO(_http.ResponseText);
        end;
        if obj.S['data.status_consulta.mensagem'] = 'SUCESSO' then
        begin
          mmoXml.Clear;
          mmoXml.Text := 'Mensagem: ' + obj.S['message'];
          for objEvento in SO(obj.S['data.eventos']) do
          begin
            if objEvento.S['status.mensagem'] = 'ERRO' then
            begin
              for objEventoOcor in SO(objEvento.S['ocorrencias']) do
              begin
                mmoXml.Text := mmoXml.Text + #13#10 + ' Status do evento: ' + objEvento.S['status.mensagem'];
                mmoXml.Text := mmoXml.Text + #13#10 + '  Codigo de erro do evento: ' + objEventoOcor.S['codigo'];
                mmoXml.Text := mmoXml.Text + #13#10 + '  Descricao do erro do evento: ' + objEventoOcor.S['descricao'];
              end;
            end;
            if objEvento.S['status.mensagem'] = 'SUCESSO' then
            begin
              mmoXml.Text := mmoXml.Text + #13#10 + ' Status do evento: ' + objEvento.S['status.mensagem'];
              mmoXml.Text := mmoXml.Text + #13#10 + ' Recibo: ' + objEvento.S['recibo'];
            end;
          end;
        end;
      end;
    except
      on E: Exception do
        mmoXml.Text := E.Message;
    end;
  end;

end;

procedure TfReinf.btnEnviarClick(Sender: TObject);
var
  url, tx2: string;
  obj: ISuperObject;
begin
//  tx2 := 'cpfcnpjtransmissor=08187168000160' + #13#10 + 'cpfcnpjempregador=' + edtEmpregador.text + #13#10 + 'versaomanual=' +
//  cbbVersao.Text + #13#10 + 'ambiente=' + IntToStr(cbbAmbiente.ItemIndex + 1) + #13#10 + mmoXml.Text;
  if mmoXml.Text <> '' then
  begin
    tx2 := 'cpfcnpjtransmissor=08187168000160' + #13#10 + 'cpfcnpjempregador=' + edtEmpregador.text + #13#10 + 'versaomanual=2' + #13#10 + 'ambiente=' + IntToStr(cbbAmbiente.ItemIndex + 1) + #13#10 + mmoXml.Text;
    mmoXml.Clear;
    url := 'http://api.tecnospeed.com.br/reinf/v1/evento/enviar/tx2';
    try
      mmoXml.Text := 'Enviando o evento!';
      _http := CoWinHttpRequest.Create;
      _http.Open('POST', url, False);
      _http.SetRequestHeader('cnpj_sh', edtCnpjSH.Text);
      _http.SetRequestHeader('token_sh', edtTokenSH.Text);
      _http.SetRequestHeader('Content-Type', 'text/tx2');
      _http.Send(tx2);
      mmoXml.Clear;
      obj := SO(_http.ResponseText);
      if obj.S['error'] <> '' then
      begin
        mmoXml.Clear;
        mmoXml.Text := 'Erro';
        mmoXml.Text := mmoXml.Text + #13#10 + ' Erro ao Enviar evento: ' + obj.S['error.message'];
      end
      else
      begin
        edtIdLote.Text := obj.S['data.id'];
        mmoXml.text := 'Mensagem: ' + obj.S['message'];
        if obj.S['data.id'] <> '' then
        begin
          mmoXml.Text := mmoXml.Text + #13#10 + ' Id de lote: ' + obj.S['data.id'];
          mmoXml.Text := mmoXml.Text + #13#10 + '  Codigo do retorno do envio: ' + IntToStr(obj.I['data.status_envio.codigo']);
          mmoXml.Text := mmoXml.Text + #13#10 + '  Mensagem do retorno do envio: ' + obj.S['data.status_envio.mensagem'];
        end;
      end;
    except
      on E: Exception do
        mmoXml.Text := E.Message;
    end;
  end
  else
    ShowMessage('� necess�rio informar o TX2!');
end;

procedure TfReinf.btnGeraTx2Click(Sender: TObject);
begin
  mmoXml.Clear;
  mmoXml.Text := 'INCLUIRR1000';
  mmoXml.Text := mmoXml.Text + #13#10 + 'tpAmb_4=' + IntToStr(cbbAmbiente.ItemIndex + 1);
  mmoXml.Text := mmoXml.Text + #13#10 + 'procEmi_5=1';
  mmoXml.Text := mmoXml.Text + #13#10 + 'verProc_6=1.0';
  mmoXml.Text := mmoXml.Text + #13#10 + 'tpInsc_8=1';
  mmoXml.Text := mmoXml.Text + #13#10 + 'nrInsc_9=08187168';
  mmoXml.Text := mmoXml.Text + #13#10 + 'iniValid_13=2017-10';
  mmoXml.Text := mmoXml.Text + #13#10 + 'fimValid_14=';
  mmoXml.Text := mmoXml.Text + #13#10 + 'classTrib_16=01';
  mmoXml.Text := mmoXml.Text + #13#10 + 'indEscrituracao_17=0';
  mmoXml.Text := mmoXml.Text + #13#10 + 'indDesoneracao_18=1';
  mmoXml.Text := mmoXml.Text + #13#10 + 'indAcordoIsenMulta_19=0';
  mmoXml.Text := mmoXml.Text + #13#10 + 'indSitPJ_20=0';
  mmoXml.Text := mmoXml.Text + #13#10 + 'nmCtt_22=Nome do Contato Teste';
  mmoXml.Text := mmoXml.Text + #13#10 + 'cpfCtt_23=12345678909';
  mmoXml.Text := mmoXml.Text + #13#10 + 'foneFixo_24=1123452345';
  mmoXml.Text := mmoXml.Text + #13#10 + 'foneCel_25=';
  mmoXml.Text := mmoXml.Text + #13#10 + 'email_26=';
  mmoXml.Text := mmoXml.Text + #13#10 + 'ideEFR_34=';
  mmoXml.Text := mmoXml.Text + #13#10 + 'cnpjEFR_35=';
  mmoXml.Text := mmoXml.Text + #13#10 + 'INCLUIRSOFTHOUSE_27';
  mmoXml.Text := mmoXml.Text + #13#10 + 'cnpjSoftHouse_28=26764821000198';
  mmoXml.Text := mmoXml.Text + #13#10 + 'nmRazao_29=Nome Razao Teste';
  mmoXml.Text := mmoXml.Text + #13#10 + 'nmCont_30=Nome Teste';
  mmoXml.Text := mmoXml.Text + #13#10 + 'telefone_31=1234567897';
  mmoXml.Text := mmoXml.Text + #13#10 + 'email_32=email.teste@gmail.com';
  mmoXml.Text := mmoXml.Text + #13#10 + 'SALVARSOFTHOUSE_27';
  mmoXml.Text := mmoXml.Text + #13#10 + 'SALVARR1000';
end;

procedure TfReinf.FormCreate(Sender: TObject);
begin
  cbbAmbiente.ItemIndex := 0;
  cbbVersao.ItemIndex := 0;
  lnklbl1.Caption := '<a href="esocial.tecnospeed.com.br">esocial.tecnospeed.com.br</a>';
end;

end.

