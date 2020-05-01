# Steps（1，2，3）
## 文件夹格式：
/path/to/project/...  
+── images  
│   +── image1.jpg  
│   +── image2.jpg  
│   +── ...  
│   +── imageN.jpg  
+── database.db  
+── project.ini  

## COLMAP使用方法：
File——New Project:
Database——Open——Prj2/database.db——Open
Image——Select——Prj2/images——Open(images文件夹的Open，里面图片选不了的) 
Save
File——New Project ——Reconstruction——Start Reconstruction

### 其中points3D.txt 文件中only need XYZ 
### 使用StoreXYZ.py 提取XYZ三点—— 存在pointsXYZ.txt中
