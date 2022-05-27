main() 
{
	int l,m,n;
	l=1;
	m=2;
	n=3;
	print(l,m,n);
	n=func(l,&m,n);
	print(l,m,n);
}

func(o,&p,q)
{
    p = o+q;
	o = p;
	print(o,p,q);
	return 999;
}