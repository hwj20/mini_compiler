int i,j,k;

main() 
{
	int l,m,n;
	l=1;
	m=2;
	n=3;
	print(l,m,n);
	n=func(l,m,n);
	print(i,j,k);
	print(n,"\n");
}

func(o,p,q)
{
	print(o,p,q);
	i=o;
	j=p;
	k=q;
	print(i,j,k);
	return 999;
}


solution 1: func (a,&b) = func(a, *b) b = *b;	// pre
{
	// when calling
	mkaddr b,v
	put v into func as the value of var
}
solution 2: put addr and value into stack when calling

