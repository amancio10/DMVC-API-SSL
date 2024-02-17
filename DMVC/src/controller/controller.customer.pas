unit controller.customer;

interface

uses
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  FireDAC.Comp.Client,               // Para conexão com o banco
  FireDAC.Phys.SQLite,               // Para conexão com o banco
  MVCFramework.SQLGenerators.Sqlite,
  MVCFramework.ActiveRecord,
  System.Generics.Collections,
  MVCFramework.Logger,
  System.JSON;

type
  [MVCNameCase(ncCamelCase)]
  TPerson = class
  private
    fFirstName: String;
    fLastName: String;
    fDOB: TDate;
  public
    property FirstName: String read fFirstName write fFirstName;
    property LastName: String read fLastName write fLastName;
    property DOB: TDate read fDOB write fDOB;
    constructor Create(FirstName, LastName: String; DOB: TDate);
  end;

  [MVCPath('/api')]
  //TCustomer = class(TMVCController)
  TCustomerController = class(TMVCController)
  private
   FDConn : TFDConnection; // Para conexão com o banco
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/reversedstrings/($Value)')]
    [MVCHTTPMethod([httpGET])]
    [MVCProduces(TMVCMediaType.TEXT_PLAIN)]
    procedure GetReversedString(const Value: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
    [MVCPath('/customers')]    // Selec todos os registros
    [MVCHTTPMethod([httpGET])]
    procedure GetCustomers;

    [MVCPath('/customers/($id)')] // Selec registros com ID
    [MVCHTTPMethods([httpGET])]
    procedure GetCustome(id : Integer);

    [MVCPath('/customers')]
    [MVCHTTPMethods([httpPOST])] // 'Postar' Dados
    procedure CreatCustomer;

    [MVCPath('/customers/($id)')] // Editar / Atualizar
    [MVCHTTPMethods([httpPUT])]
    procedure UpdateCustomer(id : Integer);

    [MVCPath('/customers/($id)')] // Delete
    [MVCHTTPMethods([httpDELETE])]
    procedure DeleteCustomer(id : Integer);

    //Sample CRUD Actions for a "People" entity
    [MVCPath('/people')]
    [MVCHTTPMethod([httpGET])]
    function GetPeople: TObjectList<TPerson>;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpGET])]
    function GetPerson(ID: Integer): TPerson;

    [MVCPath('/people')]
    [MVCHTTPMethod([httpPOST])]
    function CreatePerson([MVCFromBody] Person: TPerson): IMVCResponse;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpPUT])]
    function UpdatePerson(ID: Integer; [MVCFromBody] Person: TPerson): IMVCResponse;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpDELETE])]
    function DeletePerson(ID: Integer): IMVCResponse;

    constructor Create; override;

  end;

implementation

uses
  System.SysUtils, System.StrUtils, Model.Customer;

procedure TCustomerController.Index;
begin
  //use Context property to access to the HTTP request and response
  Render('Hello DelphiMVCFramework World');
end;

procedure TCustomerController.GetReversedString(const Value: String);
begin
  Render(System.StrUtils.ReverseString(Value.Trim));
end;

procedure TCustomerController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TCustomerController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "People" entity
procedure TCustomerController.GetCustome(id: Integer);
var
 lCustomer : TCustomer;
begin
  lCustomer := TMVCActiveRecord.GetByPK<TCustomer>(id);

  Render(lCustomer);

end;

procedure TCustomerController.GetCustomers;
var
 lCustomer : TObjectList<TCustomer>;
begin
  lCustomer := TMVCActiveRecord.SelectRQL<TCustomer>('', 0);

  Render<Tcustomer>(lCustomer);
  //Render(lCustomer);

end;

function TCustomerController.GetPeople: TObjectList<TPerson>;
var
  lPeople: TObjectList<TPerson>;
begin
  lPeople := TObjectList<TPerson>.Create(True);
  try
    lPeople.Add(TPerson.Create('Peter','Parker', EncodeDate(1965, 10, 4)));
    lPeople.Add(TPerson.Create('Bruce','Banner', EncodeDate(1945, 9, 6)));
    lPeople.Add(TPerson.Create('Reed','Richards', EncodeDate(1955, 3, 7)));
    Result := lPeople;
  except
    lPeople.Free;
    raise;
  end;
end;

function TCustomerController.GetPerson(ID: Integer): TPerson;
var
  lPeople: TObjectList<TPerson>;
begin
  lPeople := GetPeople;
  try
    Result := lPeople.ExtractAt(ID mod lPeople.Count);
  finally
    lPeople.Free;
  end;
end;

procedure TCustomerController.CreatCustomer;
var
 lCustomer : TCustomer;
begin
  lCustomer := Context.Request.BodyAs<TCustomer>;
  lCustomer.Insert;

  Render(lCustomer);
end;

constructor TCustomerController.Create;
begin // Para conexão com o banco
  inherited;
  FDConn := TFDConnection.Create(nil);
  FDConn.Params.Clear;
  FDConn.Params.Database := 'C:\Delphi\delphimvcframework-darnocian-sempare_adaptor_support\samples\data\activerecorddb.db';
  FDConn.DriverName := 'SQLite';
  FDConn.Connected := True;

  ActiveRecordConnectionsRegistry.AddDefaultConnection(FDConn);
end;

function TCustomerController.CreatePerson([MVCFromBody] Person: TPerson): IMVCResponse;
begin
  LogI('Created ' + Person.FirstName + ' ' + Person.LastName);
  Result := MVCResponseBuilder
      .StatusCode(HTTP_STATUS.Created)
      .Body('Person created')
      .Build;
end;

procedure TCustomerController.UpdateCustomer(id: Integer);
var
 lCustomer : TCustomer;
begin
  lCustomer := Context.Request.BodyAs<TCustomer>;
  lCustomer.ID := id;
  lCustomer.Update;

  Render(lCustomer);
end;

function TCustomerController.UpdatePerson(ID: Integer; [MVCFromBody] Person: TPerson): IMVCResponse;
begin
  LogI('Updated ' + Person.FirstName + ' ' + Person.LastName);
  Result := MVCResponseBuilder
    .StatusCode(HTTP_STATUS.NoContent)
    .Build;
end;

procedure TCustomerController.DeleteCustomer(id: Integer);
var
 lCustomer : TCustomer;
begin
  lCustomer := TMVCActiveRecord.GetByPK<TCustomer>(id);
  lCustomer.Delete;

  Render(TJSONObject.Create(TJSONPair.Create('result', 'Registro apagado com sucesso!')));
end;

function TCustomerController.DeletePerson(ID: Integer): IMVCResponse;
begin
  LogI('Deleted person with id ' + ID.ToString);
  Result := MVCResponseBuilder
    .StatusCode(HTTP_STATUS.NoContent)
    .Build;
end;

constructor TPerson.Create(FirstName, LastName: String; DOB: TDate);
begin
  inherited Create;
  fFirstName := FirstName;
  fLastName := LastName;
  fDOB := DOB;
end;

end.
