let title = document.getElementById('title');
let taxes = document.getElementById('taxes');
let ads = document.getElementById('ads');
let discount = document.getElementById('discount');
let price = document.getElementById('price');
let total = document.getElementById('total');
let count = document.getElementById('count');
let category = document.getElementById('category');
let create = document.getElementById('create');
let module='create';
let temp;

showdata();
//calcule total
function calcule(){
    let resulta;
    if(price.value!='' ){
        resulta=( +price.value + +taxes.value + +ads.value) 
        - +discount.value;
        total.innerHTML=resulta;
        total.style.background='green';
    }
    else{
        total.innerHTML='';
        total.style.background='red'
    }
}
// create prodact
let arra;
if( localStorage.prodact!=null){
    arra=JSON.parse(localStorage.prodact);
}
else{
    arra=[];
}

create.onclick=function()      {
   let arg={
    title:title.value.toLowerCase(),
    taxes:taxes.value,
    ads:ads.value,
    discount:discount.value,
    price:price.value,
    total:total.innerHTML,
    count:count.value,
    category:category.value.toLowerCase(),
  
   }

    if(title.value!=''&&price.value!=''
        &&category.value!=''
    ){
        if ( module=='create'  ){
    
            if( arg.count>1  ){
                for(let i=0 ;i<arg.count;i++){
                    arra.push(arg);
                }
               }
               else{
                arra.push(arg);
              
               }
               


        
           }
        else {
            arra[ temp ] = arg;
            module='create';
            create.innerHTML='create';
            total.style.background='red';
            count.style.display='block';
        
           }
           cleardata();
    }
  
           //save
           localStorage.setItem('prodact',   JSON.stringify(arra)   )
        
           
           showdata();
     }

 


   

     showdata();
   
 








//save localstorage
//clear inputs
function cleardata(){
    title.value='';
    taxes.value='';
    ads.value='';
    discount.value='';
    price.value='';
    total.innerHTML='';
    count.value='';
    category.value='';


}



// read
function showdata() {
    calcule();

    let arra;
if( localStorage.prodact!=null){
    arra=JSON.parse(localStorage.prodact);
}
else{
    arra=[];
}
    let table = '';
   
    for (let i = 0; i < arra.length; i++) {
        table += `
        <tr>
          <td>${i}</td>
          <td>${arra[i].title}</td>
          <td>${arra[i].price}</td>
          <td>${arra[i].taxes}</td>
          <td>${arra[i].ads}</td>
          <td>${arra[i].discount}</td>
          <td>${arra[i].total}</td>
          <td>${arra[i].category}</td> 
          <td  onclick="update(${i})"  id="update"><button>update</button></td>
          <td onclick=" dellete('${i}')"   id="delete"><button>delete</button></td>
        </tr>
        `;
    }
    document.getElementById('tbody').innerHTML = table;
   let delleteall=document.getElementById('delleteall');
    if(arra.length>0){
      
        delleteall.innerHTML=`
        <button onclick="delleteall()" >delete all</button>
        `
    }else{
        delleteall.innerHTML='';
    }


create.innerHTML='create';
total.style.background='red';

}


 showdata();


//count
//delet
function dellete(x){
    arra.splice(x,1);
    localStorage.setItem('prodact',JSON.stringify(arra));
    showdata();


}



function delleteall(){
localStorage.clear();
arra.splice(0);
showdata();

}

function update(x){
    title.value=arra[x].title;
    price.value=arra[x].price;
    taxes.value=arra[x].taxes;
    taxes.value=arra[x].taxes;
    ads.value=arra[x].ads;
    discount.value=arra[x].discount;
    calcule();
    count.style.display='none';
    category.value=arra[x].category;
    create.innerHTML='update';
    module='update';
    temp=x;
   
    scroll({
        top:0,
        behavior:'smooth'

    })

}
let searchmode='title';
function getsearchmode(id){
    let search= document.getElementById('search');
    if(id=='searchtitle'){
     searchmode='title'  ;
    

    }
    else{
        searchmode='category'  ;
        
    }
        searchmode='category'  ;
    search.Placeholder='search by '+searchmode;

    search.focus();
    search.value='';
    
    showdata();

}
function searchData(value){
    let table='';
    for(let i=0;i<arra.length;i++){
if(searchmode=='title'){

    if(arra[i].title.includes(value.toLowerCase())){
       
        table += `
        <tr>
          <td>${i}</td>
          <td>${arra[i].title}</td>
          <td>${arra[i].price}</td>
          <td>${arra[i].taxes}</td>
          <td>${arra[i].ads}</td>
          <td>${arra[i].discount}</td>
          <td>${arra[i].total}</td>
          <td>${arra[i].category}</td> 
          <td  onclick="update(${i})"  id="update"><button>update</button></td>
          <td onclick=" dellete('${i}')"   id="delete"><button>delete</button></td>
        </tr>
        `;
    }

  
}else{
    if(arra[i].category.includes(value.toLowerCase())){
       
        table += `
        <tr>
          <td>${i}</td>
          <td>${arra[i].title}</td>
          <td>${arra[i].price}</td>
          <td>${arra[i].taxes}</td>
          <td>${arra[i].ads}</td>
          <td>${arra[i].discount}</td>
          <td>${arra[i].total}</td>
          <td>${arra[i].category}</td> 
          <td  onclick="update(${i})"  id="update"><button>update</button></td>
          <td onclick=" dellete('${i}')"   id="delete"><button>delete</button></td>
        </tr>
        `;
    }
}
    }
document.getElementById('tbody').innerHTML = table;
}
