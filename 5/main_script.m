# Prevent Octave from thinking that this# is a function file:1;clear;function [A] = load_sparse(filename, m, n)  l = load(filename);  A = sparse(l(:,1:2)(:), fliplr(l(:,1:2))(:), 1, m, n);  #[a,b] = textread(filename, "%d %d");endarenas = "arenas-jazz/out.arenas-jazz";amazon = "com-amazon/out.com-amazon";reactome = "reactome/out.reactome";#UNCOMMENT NEEDEDarenas_sparce = load_sparse(arenas,2742,2742);#amazon_sparce = load_sparse(amazon,925872,925872);#reactome_sparce = load_sparse(reactome,147547,147547);#1. for a row find edges like [1,2], [1,3] [1,4]#2. take n and n+1 edge, and see if [second element of n, second element of n+1] is also an edgefunction N = numberOfTriangles(sparce_matrix)  N=0;  for i = 1:rows(sparce_matrix)    edgesI = {};    iter = 0;    for j = i+1:columns(sparce_matrix)      if nnz(sparce_matrix(i,j)) == 1        iter= iter + 1;        edgesI{iter} = j;      endif    endfor    for k = 1:length(edgesI)-1      for kk = k+1:length(edgesI)        firstElement = edgesI{k};        secondElement = edgesI{kk};        if nnz(sparce_matrix(firstElement, secondElement)) == 1          N = N+1;          #printf ("%d-%d-%d is a triangle\n", i, firstElement, secondElement);         endif      endfor    endfor  endforendfunction#UNCOMMENT NEEDEDt = cputime ();#arenas_tri = numberOfTriangles(arenas_sparce)#amazon_tri = numberOfTriangles(amazon_sparce)#reactome_tri = numberOfTriangles(reactome_sparce)cputime () -t# TASK 2fb = "facebook-wosn-links/out.facebook-wosn-links";fb_sparce = load_sparse(fb, 817035, 817035);function L = localClustering (sparce_matrix)  L = [];  for i = 1:rows(sparce_matrix)    N = 0;    edgesI = {};    iter = 0;    for j = i+1:columns(sparce_matrix)      if nnz(sparce_matrix(i,j)) == 1        iter= iter + 1;        edgesI{iter} = j;      endif    endfor    for k = 1:length(edgesI)-1      for kk = k+1:length(edgesI)        firstElement = edgesI{k};        secondElement = edgesI{kk};        if nnz(sparce_matrix(firstElement, secondElement)) == 1          N = N+1;         endif      endfor    endfor    localClustering = 0;    if iter != 0     localClustering = N/iter;    endif    L(i) = localClustering;    printf ("for user %d C(u) = %f\n", i,localClustering)  endfor  L=L';endfunction#mean local clusteringlocClustering = localClustering(fb_sparce);globalClustering_v1 = mean(locClustering)