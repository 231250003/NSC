int main(){
  const int x=2;
  const int a[3][3]={{1,2,3}};
  {
    int x;
    x=4;
  }
  return x+a[0][0];
}