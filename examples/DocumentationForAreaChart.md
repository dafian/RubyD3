# Documentation for an Area Chart
Per praticit� scrivo la documentazione usando come esempio il file area.rb in `examples\7_pv_d3examples\area\.`  
Prima riga `$:.unshift(File.dirname(__FILE__)+"/../../../lib")` carica il path da cui prendere la libreria; attenzione per� al fatto che il path cambia a seconda di dove si trova il file che stai creando rispetto alla libreria Rubyvis. Quindi `require 'rubyvis'` carica il file ruby necessario per poter usare la libreria. Sottolineo il fatto che entrambi i comandi sono necessari. Il metodo `areacharter` riceve in ingresso come dati una hash i quali elementi hanno come attributi le coordinate :x e :y e come secondo parametro il path(opzionale) in cui verr� salvato il file SVG di output. C'� un file `areacharter.rb` di test nella medesima directory.  
Successivamente vengono settati delle costanti che verranno utilizzate rispettivamente per la larghezza(w), altezza(h) e �shifting�(p) del pannello principale sulla quale costruiremo il nostro grafico.  Per quanto riguarda lo �shifting� questo non � altro che un valore che verr� utilizzato per dare un certo distacco del pannello dai margini della pagina.  
Ora settiamo i domini del nostro pannello rispettivamente per l�asse delle ascisse e per le ordinate, ovvero prendiamo come esempio l�ascissa. Ci dice che i valori assumeranno valori compresi tra 0 e 1 estremi compresi che verranno interpolati come grandezze sul grafico che andranno da 0(l�estremo sinistro del panel) a w(quello che sar� l�estremo destro del panel). Una nota particolare per il dominio dell�asse delle y in cui si pu� notare che h si trova prima dello 0, questo perch� SVG ha  l�origine degli assi in alto a sinistra e l�asse delle ordinate si sviluppa verso il basso(ovviamente le ascisse si muovono normalmente verso destra), quindi utilizzando una scale da 0 a 1 avremo 0 come primo valore che coincide con l�origine del nostro grafico e deve essere nel punto pi� basso del pannello ovvero ad altezza h cos� poi da avere tutti i valori che crescono sull�asse delle y sempre pi� vicini al punto 0,0 in alto a sinistra.  
Ora iniziamo a costruire realmente il nostro grafico. Per prima cosa `vis = pv.Panel.new() do` ci permette di inizializzare il nostro pannello e di seguito vengono settati gli attributi: che faranno parte del tag <svg>.  
Poi troviamo l�inizializzazione di �group� che corrisponde al tag <g> del linguaggio SVG con un attributo transform=translate che trasla tutto ci� che � all�interno di questo tag.  
Quindi un altro group che presenta un attributo class che non � altro che un nome identificativo e un attributo data che ha come argomento x.ticks(10), ovvero � un array di dati formato da 10 ticks sugli assi pi� uno per ogni asse per l�orgine. Quando � presente l�attributo data con dimensione n vengono creati n oggetti di quel tipo(compreso i figli) dove ognuno usa un valore dell�array di dati.  
In group troveremo 4 oggetti: 2 rule e 2 label. Le rule non sono altro che le linee del piano cartesiano ed ognuno ha presente i suoi attributi. L�unico particolare per la rule � l�uso della variabile d per esempio in `stroke {|d| d==0 ? "#000" : "#eee"}` dove quel d sar� il dato ereditato dal group al livello immediatamente precedente(o se fosse stato settato l�array data in rule sarebbe stato uno dei suoi valori). Per quanto riguarda i due label essi corrispondono ai valori sugli assi, uno per l�asse delle x e uno per l�asse delle y e gli attributi sono stati opportunamente settati.  
Adesso troviamo l�area che ci permette di visualizzare l�area del nostro grafico. I campo data � settato con i dati citati all�inizio, in questo caso per� non vengono create 20 istanze di data ma una sola perch� area, line e panel producono un solo output unificato; poi y0 � il limite inferiore massimo su cui �si poggia� la nostra area, x e y1 invece creano proprio l�area a seconda di quello che sono i nostri dati costituiti da valori compresi tra 0 e 1 e che quindi vengono interpolati nei valori del codominio, per esempio tramite la funzione x.scale(d.x) per l�asse delle x; infine riempie l�area con il colore �lightsteelblue�.  
Dopo l�area troviamo la linea che verr� visualizzata su di essa e di questa � possibile intuire la costruzione delle coordinate che sono utilizzate perch� la line � quasi una parte dell�area dove manca per� il valore del limite inferiore dell�area. Inoltre � necessario settare il fill a �none� per un corretto utilizzo della line.  
Infine troviamo dot che va a formare gli oggetti circle dell� immagine. Anche qui troviamo una grande somiglianza con un altro oggetto, ovvero la line, proprio perch� i vari circle si poggiano proprio su di essa e poi vediamo settati gli attributi. Qui troviamo l'attributo shape_radius che non � altro che il raggio dei dot che per� verr� visualizzato nel file SVG come l'attributo r delle forme circle, questo per dire che ci sono alcuni attributi che potrebbero avere dei nomi diversi da quelli che verranno visualizzati nell'SVG finale. Alla fine di questa documentazione verr� spiegato come provvedere a questo problema.  
Adesso abbiamo creato tutto il nostro grafico come una struttura dati in Ruby, ma che non � ancora pronta per essere visualizzata. Quindi � necessario fare la chiamata `vis.render()` che costruisce una struttura definitiva degli elementi della scena.  
A questo punto abbiamo quasi finito, manca l�ultimo passo ovvero la lettura di questi elementi della scena e la stampa su file. Come si pu� intuire f corrisponde allo stream su file e la chiamata `vis.to_svg` non fa altro che leggere gli elementi della scena per stampare tutte le linee di codice del file SVG risultante, che troveremo nel path indicato in apertura dello streaming.


### Come gestire gli Attributi degli Oggetti del Panel  
E� possibile settare altri attributi, che potrebbero non essere stati previsti da Rubyvis, agli oggetti utilizzati in questa libreria. Per esempio se volessimo settare un attributo �qwerty�(� solo un esempio, l�attributo deve essere previsto dall�SVG) per un oggetto di tipo dot, � sufficiente aggiungere in rubyvis\lib\scene\svg_dot.rb nella struttura dati  
&nbsp;&nbsp;&nbsp;&nbsp;svg = {  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"class" => s.classdot,     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"shape-rendering"=> s.shape_rendering,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"pointer-events"=> s.events,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"cursor"=> s.cursor,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"fill"=> s.fill,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"fill-opacity"=> s.fill_opacity,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke"=> s.stroke,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke-opacity"=> s.stroke_opacity,  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"stroke-width"=> s.stroke_width  
&nbsp;&nbsp;&nbsp;&nbsp;}  
la stringa `�qwerty�=> s.qwerty` per esempio nell�ultima riga(se non fosse l�ultima riga � necessario aggiungere la virgola alla fine della stringa), poi aggiungere in `rubyvis\lib\mark\dot.rb` nella lista degli `attr_accessor_dsl` l�attributo `:qwerty` e farlo anche nel file `rubyvis\lib\sceneelement.rb` nella lista degli attributi `attr_accessor`. Ora � sufficiente scrivere in costruzione dell�oggetto dot l�attributo qwerty �VALORE� ad esempio  
&nbsp;&nbsp;&nbsp;&nbsp;dot do  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;data data  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shape_radius(3.5)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cx {|d| x.scale(d.x)}  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cy {|d| y.scale(d.y)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fill "#fff"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stroke "steelblue"  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;classdot("area")  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;qwerty �VALORE�  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stroke_width "1.5px"  
&nbsp;&nbsp;&nbsp;&nbsp;end  
ed il gioco � fatto!  
Ovviamente sarebbe meglio prima di creare l'attributo per l'oggetto object controllare nel rispettivo file `svg_object.rb` se nella sezione citata prima se fosse gi� possibile utilizzare tale attributo ma che � settato sotto altro nome come abbiamo visto per l'attributo shape_radius dell'oggetto dot.