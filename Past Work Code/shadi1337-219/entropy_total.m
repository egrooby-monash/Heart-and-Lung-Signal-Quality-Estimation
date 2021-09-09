z=zscore(entropy_sys_n);
indicies_p_s=find(abs(z)>1.5);
entropy_sys_n(indicies_p_s)=0;
ind=find(entropy_sys_n);
entropy_sys_n_new=entropy_sys_n(ind);

mean_entropy_sys_n=mean(entropy_sys_n_new);



z=zscore(entropy_sys_ab);
indicies_p_s=find(abs(z)>1.9);
entropy_sys_ab(indicies_p_s)=0;
ind=find(entropy_sys_ab);
entropy_sys_ab_new=entropy_sys_ab(ind);

mean_entropy_sys_ab=mean(entropy_sys_ab_new);


z=zscore(mean_power_sys_ab);
indicies_p_s=find(abs(z)>1.5);
mean_power_sys_ab(indicies_p_s)=0;
ind=find(mean_power_sys_ab);
mean_power_sys_ab_new=mean_power_sys_ab(ind);

mean_mean_power_sys_ab=mean(mean_power_sys_ab_new);

