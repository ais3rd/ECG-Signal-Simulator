object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 192
    Top = 300
    Width = 69
    Height = 15
    Caption = 'Time Range :'
  end
  object Chart1: TChart
    Left = 16
    Top = 24
    Width = 600
    Height = 250
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'TChart')
    View3D = False
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      HoverElement = [heCurrent]
      Title = 'MLII'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      HoverElement = [heCurrent]
      Title = 'V5'
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Button1: TButton
    Left = 272
    Top = 336
    Width = 89
    Height = 25
    Caption = 'Cari Data ECG'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Previous'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 472
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Next'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ComboBox1: TComboBox
    Left = 272
    Top = 297
    Width = 145
    Height = 23
    TabOrder = 4
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
  object OpenDialog1: TOpenDialog
    Left = 384
    Top = 336
  end
end
