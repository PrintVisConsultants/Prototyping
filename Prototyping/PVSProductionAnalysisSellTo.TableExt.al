tableextension 50100 "PVS Production Analysis SellTo" extends "PrintVis Production Analysis"
{
    fields
    {
        field(50100; "Sell-to No."; Code[20])
        {
            CalcFormula = lookup("PVS Case"."Sell-To No." where("Order No." = field("PrintVis Order No.")));
            Caption = 'Sell-to No.';
            DataClassification = CustomerContent;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; "Sell-to Name"; Text[100])
        {
            CalcFormula = lookup("PVS Case"."Sell-To Name" where("Order No." = field("PrintVis Order No.")));
            Caption = 'Sell-to Name';
            DataClassification = CustomerContent;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
