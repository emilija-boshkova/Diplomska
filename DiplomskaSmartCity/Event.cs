
/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
[System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
public partial class nastani
{

    private nastaniNastan[] nastanField;

    /// <remarks/>
    [System.Xml.Serialization.XmlElementAttribute("nastan")]
    public nastaniNastan[] NastaniField
    {
        get
        {
            return this.nastanField;
        }
        set
        {
            this.nastanField = value;
        }
    }
}

/// <remarks/>
[System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
public partial class nastaniNastan
{

    private ushort nastan_idField;

    private string shtoField;

    private string gradField;

    private string datumField;

    private decimal latField;

    private decimal lngField;

    private string opisField;

    /// <remarks/>
    public ushort nastan_id
    {
        get
        {
            return this.nastan_idField;
        }
        set
        {
            this.nastan_idField = value;
        }
    }

    /// <remarks/>
    public string shto
    {
        get
        {
            return this.shtoField;
        }
        set
        {
            this.shtoField = value;
        }
    }

    /// <remarks/>
    public string grad
    {
        get
        {
            return this.gradField;
        }
        set
        {
            this.gradField = value;
        }
    }

    /// <remarks/>
    public string datum
    {
        get
        {
            return this.datumField;
        }
        set
        {
            this.datumField = value;
        }
    }

    /// <remarks/>
    public decimal lat
    {
        get
        {
            return this.latField;
        }
        set
        {
            this.latField = value;
        }
    }

    /// <remarks/>
    public decimal lng
    {
        get
        {
            return this.lngField;
        }
        set
        {
            this.lngField = value;
        }
    }

    /// <remarks/>
    public string opis
    {
        get
        {
            return this.opisField;
        }
        set
        {
            this.opisField = value;
        }
    }
}

