/*

HTTP 请求的内容格式，告诉服务器的
Content-Type
multipart/form-data; boundary=可以是数字，字母的任意组合

1. boundary(分隔线)，要求和 Content-Type 中保持一致
2. name 是上传文件脚本中的字段名 `userfile`，提示每个公司的字段名是不一样的，可以咨询后台人员
3. filename 是保在服务器上的文件名
4. Content-Type 上传文件的文件类型
    大类型/小类型
    text/plain
    text/html
    text/xml
    image/png
    image/jpg
    image/gif
    application/json

    application/octet-stream (文件流) 可以适合任意上传的文件

=================
--boundary\r\n
Content-Disposition: form-data; name="userfile"; filename="111.txt"\r\n
Content-Type: application/octet-stream\r\n\r\n

上传文件的二进制数据

\r\n--boundary--\r\n
=================

如果要在 iOS 中，实现文件上传，需要自己拼接以上内容！

大多数服务器，允许直接使用 \n，但是有些服务器不行，新浪的服务器！

以上格式是 HTTP 协议定义的！

# 上传多个文件

=================
--boundary\r\n
Content-Disposition: form-data; name="userfile[]"; filename="111.txt"\r\n
Content-Type: application/octet-stream\r\n\r\n

二进制数据
\r\n
=================
--boundary\r\n
Content-Disposition: form-data; name="userfile[]"; filename="222.txt"\r\n
Content-Type: application/octet-stream\r\n\r\n

二进制数据
\r\n
=================
--boundary\r\n
Content-Disposition: form-data; name="status"\r\n\r\n

hello world
\r\n
=================
--boundary--


*/