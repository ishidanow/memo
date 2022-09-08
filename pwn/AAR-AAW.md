AAR(Arbitrary Address Read)：任意アドレスの読み出し
AAW(Arbitrary Address Write)：任意アドレスの書き込み

## AAR手法：アドレスリーク
<details>
<summary>GOTの読み出し</summary>

一度実行済みの関数のGOTを読み出すことでリーク可能。

※PIEの場合は、.text領域のリークが事前に必要

</details>

<details>
<summary>文字列データと結合して読み出し</summary>

```c
read(buf, size, src);
printf(buf);
```

上記のようなコードの場合に、
スタック上にライブラリ関数への戻り値等がある場合、<br>
bufが格納されるアドレスからライブラリ関数への戻り値が格納されている<br>
アドレスまでの間にある"\x00"を適当な値に書き換えてあげると、<br>
printf実行時にライブラリのアドレスがリークされる場合がある。

</details>

<details>
<summary>任意パスをreadできる場合</summary>

`/proc/self/maps`<br>
  ![image](https://user-images.githubusercontent.com/82632174/189107591-3b362f30-3de4-42f5-ad01-ad4cad2bcacf.png)

</details>

<details>
<summary>Use After Freeによるリーク</summary>

Use After Freeにより、unsortedbinの先頭のbk or 末尾のfd を参照することで、
main_arena(厳密にはbin_at(1)=top)のアドレスをリーク可能。

<details>
<summary>参考:glibc2.27のソースコード(glibc/malloc/malloc.c)</summary>

![image](https://user-images.githubusercontent.com/82632174/189108060-72eb831c-2eaa-49b9-b2dd-26072e5c1a93.png) <br>

※以下文字列を使用している箇所の近傍にmain_arenaのアドレスを使用している箇所(_int_malloc)があることがわかる。<br>
`!victim || chunk_is_mmapped (mem2chunk (victim)) || &main_arena == arena_for_chunk (mem2chunk (victim))` <br>
※上記_int_mallocの第二引数には、_libc_malloc(=malloc)の第一引数がセットされる

</details>

<details>
<summary>参考：glibc2.27のデコンパイル結果</summary>

![image](https://user-images.githubusercontent.com/82632174/189108479-35ff72f7-1327-4419-992c-34febe8fd1ea.png) <br>
![image](https://user-images.githubusercontent.com/82632174/189108523-df9c5775-c5f4-44df-9ae1-9758b8c861e7.png) <br>
※以下文字列を使用している箇所の近傍に、mallocの第一引数を第二引数として利用している関数あり<br>
　⇒上記関数の第一引数(0x004ebc40)がmain_arenaのアドレス<br>
`!victim || chunk_is_mmapped (mem2chunk (victim)) || &main_arena == arena_for_chunk (mem2chunk (victim))`

</details>

</details>

## AAW手法
今後まとめる

<details>
<summary>BOF ret2pltによるwriteの呼び出し</summary>



</details>

<details>
<summary>Double Free</summary>

BOF ret2pltによるwriteの呼び出しglibc2.28以前のtcacheにはDouble Freeチェック機構なし。

</details>
