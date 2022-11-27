function save_spiephen_par(pathsv, centroids_L,centroids_nonL,localFeatures_L,localLabels_L,contextFeatures_L,contextualLabels_L,graphInterplayFeatures,graphInterplayLabels)
save(pathsv, 'centroids_L','centroids_nonL','localFeatures_L','localLabels_L','contextFeatures_L','contextualLabels_L','graphInterplayFeatures','graphInterplayLabels');
end