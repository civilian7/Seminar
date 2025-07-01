object ServerMethods1: TServerMethods1
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=datasnap'
      'User_Name=datasnap'
      'Password=P@55w0rd!@'
      'Server=fullbit.duckdns.org'
      'CharacterSet=utf8'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 88
    Top = 32
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from USRS')
    Left = 88
    Top = 112
  end
  object UserList: TDataSetProvider
    DataSet = FDQuery1
    Constraints = False
    Options = [poIncFieldProps, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 88
    Top = 200
  end
end
