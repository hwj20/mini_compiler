int i,j,k,l,m;
i=1;
j=2;
k=3;

main()
{
	j = f(i,j,k);
	print(j);
}

f(i,j,k){
	int u,v,w;
	u = i+j+k;
	v = i+j+k;
	w = u+v;
	return w;
}