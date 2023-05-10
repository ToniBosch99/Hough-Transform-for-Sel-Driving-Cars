[Xleft, Yleft, Xright, Yright] = mask_creation([1.214125357875358,-1.468756381187631e+03], [-1.352422907488986,1.031092511013216e+03], 1920, 300);

mask_left = poly2mask(Xleft', Yleft', 721, 1920);
bin_mask_left = im2uint8(imfill(mask_left, 'holes'));


mask_right = poly2mask(Xright', Yright', 721, 1920);
bin_mask_right = im2uint8(imfill(mask_right, 'holes'));

bin_mask = bitor(bin_mask_left, bin_mask_right);

figure;
imshow(bin_mask)