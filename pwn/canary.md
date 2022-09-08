## Canaryとは

![image](https://user-images.githubusercontent.com/82632174/189110264-ed3446fc-d226-4146-bb0f-7a3806060072.png) <br>

※Canaryはカーネルの乱数生成器によってつくられる
※ELF起動時に設定される点に注意。ELFが動いている間はCanaryは変わらない。

参考：ELF Auxiliary Vectorsの確認
![image](https://user-images.githubusercontent.com/82632174/189110563-a3a17c4d-0390-435a-854f-3a4d16c4a34e.png) <br>
※AT_RANDOMのアドレスが指す領域にある値の先頭1byteを0にした値がCanaryになる <br>
![image](https://user-images.githubusercontent.com/82632174/189110940-8fcebff8-7dde-432a-86c9-5708e4f6057f.png) <br>
※AT_RANDOMの値とCanaryが一致していることが分かる
