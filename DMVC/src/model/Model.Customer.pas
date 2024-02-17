unit Model.Customer;

interface

 uses MVCFramework.ActiveRecord;

 type
  [MVCTable('customers')]
  TCustomer = class(TMVCActiveRecord)
  private
    [MVCTableField('id', [foPrimaryKey, foAutoGenerated])]
    FID: Integer;
    [MVCTableField('code')]
    Fcode: string;
    [MVCTableField('rating')]
    Frating: Integer;
    [MVCTableField('note')]
    Fnote: string;
    [MVCTableField('description')]
    Fdescription: string;
    [MVCTableField('city')]
    Fcity: string;
    procedure Setcity(const Value: string);
    procedure Setcode(const Value: string);
    procedure Setdescription(const Value: string);
    procedure SetID(const Value: Integer);
    procedure Setnote(const Value: string);
    procedure Setrating(const Value: Integer);
  public
   property ID : Integer read FID write SetID;
   property code : string read Fcode write Setcode;
   property description : string read Fdescription write Setdescription;
   property city : string read Fcity write Setcity;
   property note : string read Fnote write Setnote;
   property rating : Integer read Frating write Setrating;
  end;

implementation

{ TCustomer }

procedure TCustomer.Setcity(const Value: string);
begin
  Fcity := Value;
end;

procedure TCustomer.Setcode(const Value: string);
begin
  Fcode := Value;
end;

procedure TCustomer.Setdescription(const Value: string);
begin
  Fdescription := Value;
end;

procedure TCustomer.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TCustomer.Setnote(const Value: string);
begin
  Fnote := Value;
end;

procedure TCustomer.Setrating(const Value: Integer);
begin
  Frating := Value;
end;

end.
