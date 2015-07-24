-- lua5.1 makevideo.lua newfile.wmv DSC0*.jpg

require"imlua"
require"imlua_wmv"
--require"imlua_avi"

-- Margin parameters
new_filename = arg[1]
filename1 = arg[2]
if (not new_filename or not filename1) then
  error("invalid parameters")
end

function ProcessImageFile(file_name, ifile)
  print("Loading File: "..file_name)
  local image, err = im.FileImageLoad(file_name);
  if (err and err ~= im.ERR_NONE) then
    ifile:Close()
    error(im.ErrorStr(err))
  end

  err = ifile:SaveImage(image)
  if (err and err ~= im.ERR_NONE) then
    ifile:Close()
    error(im.ErrorStr(err))
  end

  image:Destroy()
end

--ifile = im.FileNew(new_filename, "AVI")
ifile = im.FileNew(new_filename, "WMV")

ifile:SetAttribute("FPS", im.FLOAT, {15}) -- Frames per second

file_count = 0
for index,value in ipairs(arg) do
  if (index > 5) then
    ProcessImageFile(arg[index], ifile)
    file_count = file_count + 1
  end
end

ifile:Close()

if (file_count > 1) then
  print("Processed "..file_count.." Files.")
end
print("Saved File: "..new_filename)
