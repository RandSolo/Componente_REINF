object frmReinf: TfrmReinf
  Left = 617
  Top = 154
  ClientHeight = 604
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Ambiente: TLabel
    Left = 189
    Top = 39
    Width = 49
    Height = 13
    Caption = 'Ambiente:'
  end
  object lbl1: TLabel
    Left = 8
    Top = 161
    Width = 57
    Height = 13
    Caption = 'Certificados'
  end
  object lbl2: TLabel
    Left = 367
    Top = 39
    Width = 74
    Height = 13
    Caption = 'Vers'#227'o Manual:'
  end
  object edtCnpjSH: TLabeledEdit
    Left = 8
    Top = 16
    Width = 257
    Height = 21
    EditLabel.Width = 140
    EditLabel.Height = 13
    EditLabel.Caption = 'CPF / CNPJ SoftWare House:'
    TabOrder = 0
  end
  object edtTokenSH: TLabeledEdit
    Left = 271
    Top = 16
    Width = 266
    Height = 21
    EditLabel.Width = 115
    EditLabel.Height = 13
    EditLabel.Caption = 'Token SoftWare House:'
    TabOrder = 1
  end
  object edtEmpregador: TLabeledEdit
    Left = 8
    Top = 56
    Width = 171
    Height = 21
    EditLabel.Width = 119
    EditLabel.Height = 13
    EditLabel.Caption = 'CPF / CNPJ Empregador:'
    TabOrder = 2
  end
  object cbAmbiente: TComboBox
    Left = 189
    Top = 56
    Width = 170
    Height = 21
    TabOrder = 3
    Items.Strings = (
      '1 - Produ'#231#227'o'
      '2 - Homologa'#231#227'o')
  end
  object edtTemplates: TLabeledEdit
    Left = 8
    Top = 96
    Width = 529
    Height = 21
    EditLabel.Width = 97
    EditLabel.Height = 13
    EditLabel.Caption = 'Caminho Templates:'
    TabOrder = 4
    Text = 'C:\Program Files\TecnoSpeed\Reinf\Arquivos\Templates\'
  end
  object edtEsquemas: TLabeledEdit
    Left = 8
    Top = 136
    Width = 529
    Height = 21
    EditLabel.Width = 96
    EditLabel.Height = 13
    EditLabel.Caption = 'Caminho Esquemas:'
    TabOrder = 5
    Text = 'C:\Program Files\TecnoSpeed\Reinf\Arquivos\Esquemas\'
  end
  object cbCertificado: TComboBox
    Left = 8
    Top = 176
    Width = 529
    Height = 21
    TabOrder = 6
  end
  object btnConfigurar: TButton
    Left = 8
    Top = 203
    Width = 529
    Height = 26
    Caption = 'Configurar Componente'
    TabOrder = 7
    OnClick = btnConfigurarClick
  end
  object btnTx2: TButton
    Left = 9
    Top = 235
    Width = 92
    Height = 25
    Caption = 'Gerar Tx2'
    TabOrder = 8
    OnClick = btnTx2Click
  end
  object btnXml: TButton
    Left = 120
    Top = 235
    Width = 92
    Height = 25
    Caption = 'Gerar Xml'
    TabOrder = 9
    OnClick = btnXmlClick
  end
  object btnAssinar: TButton
    Left = 231
    Top = 235
    Width = 90
    Height = 25
    Caption = 'Assinar'
    TabOrder = 10
    OnClick = btnAssinarClick
  end
  object btnEnviar: TButton
    Left = 340
    Top = 235
    Width = 90
    Height = 25
    Caption = 'Enviar'
    TabOrder = 11
    OnClick = btnEnviarClick
  end
  object btnConsultar: TButton
    Left = 447
    Top = 235
    Width = 90
    Height = 25
    Caption = 'Consultar'
    TabOrder = 12
    OnClick = btnConsultarClick
  end
  object edtIdLote: TLabeledEdit
    Left = 8
    Top = 280
    Width = 529
    Height = 21
    EditLabel.Width = 99
    EditLabel.Height = 13
    EditLabel.Caption = 'Identifiador do Lote:'
    TabOrder = 13
  end
  object mmoXml: TMemo
    Left = 8
    Top = 307
    Width = 529
    Height = 289
    ScrollBars = ssVertical
    TabOrder = 14
  end
  object cbVersao: TComboBox
    Left = 367
    Top = 56
    Width = 170
    Height = 21
    TabOrder = 15
    Items.Strings = (
      'vm13')
  end
end
