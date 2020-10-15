# coolpup.py https://coolpuppy.readthedocs.io/en/latest/index.html
# cooltools https://cooltools.readthedocs.io/en/latest/#

# step1 using cooltools to convert .hic files to .cool files
hic2cool convert WT_GM.allValidPairs.hic WT_GM.allValidPairs.res5kb.cool -r 5000 -p 20

# step2 plot the local heatmap from bed files
coolpup.py --weight_name KR --n_proc 20 --local --pad 30 --ignore_diags 0 ../../cools/WT_GM.allValidPairs.res3kb.cool /lustre1/lch3000_pkuhpc/liuyt/ChenQ/Hi-C/coolpup/regions/CTCF.WT-DMvsWT-GM.upinDM.log2FC1.PValue001.bed

# step3 plot the loop heatmap from bedpe files 
coolpup.py --weight_name KR --n_proc 20 --mindist 20000 --maxdist 2000000 --ignore_diags 0 ../../cools/WT_GM.allValidPairs.res3kb.cool /lustre1/lch3000_pkuhpc/liuyt/ChenQ/Hi-C/coolpup/regions/coordinate_files/CisCoordinates_selfinteractions_intraWTGMTAD_between_CTCF.WT-DMvsWT-GM.downinDM.log2FC1.PValue001.bedpe_OrderTwoAnchors.bedpe
