main()
{
    int i,j,c;
    i = 1;
    j = 2;
    c = 3;
    if(i < j)
    {
        print("pass 1");
    }
    if(i <= j)
    {
        print("pass 2");
    }
    if(c > i)
    {
        print("pass 3");
        i = 4;
    }
    if(c >= i)
    {
        print("wrong 4");
    }
    c = 2;
}
