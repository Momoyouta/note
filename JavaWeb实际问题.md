## I.文件上传与存储
<details>
<summary></summary>

### 上传文件大小设置
配置springboot文件

### 本地储存
- 使用springboot中的MultipartFile接受请求
- 使用MultipartFile方法getOriginalFilename获取原始文件名和transferTo储存到本地磁盘方法
- 避免文件重名:截取原始文件后缀配合UUID合成新文件名
```java
 @PostMapping("/upload")
    public Result upload(String username, Integer age, MultipartFile image) throws IOException {
        //获取文件名
        String originalFilename=image.getOriginalFilename();
        //构建新文件名
        String newFileName= UUID.randomUUID().toString()+originalFilename.substring(originalFilename.lastIndexOf("."));
        //保存文件
        image.transferTo(new File("C:\\Users\\fairy\\Desktop\\头像\\"+newFileName));
        return Result.success();
    }
}
```

### 云储存



</details>

---

<details>
<summary> </summary>

</details>

<details>
<summary> </summary>

</details>

<details>
<summary> </summary>

</details>
