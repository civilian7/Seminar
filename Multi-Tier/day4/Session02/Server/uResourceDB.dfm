object DBResource: TDBResource
  Height = 243
  Width = 398
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 56
    Top = 48
  end
  object UserList: TDataSetProvider
    DataSet = FDQuery1
    Constraints = False
    Left = 56
    Top = 128
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=datasnap'
      'User_Name=datasnap'
      'Password=P@55w0rd!@'
      'Server=fullbit.duckdns.org'
      'CharacterSet=utf8'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 152
    Top = 48
  end
end
