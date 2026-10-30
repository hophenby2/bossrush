"""只验证有物理意义的性质，不把五张卡的名字塞进评分公式。"""
import unittest
import numpy as np
from model import Parameters,profile,gap_width,path_dp,emission_scatter,BARRIER

def bullet(frame,ident,x,y,r=3,vx=0,vy=-2):
    return [frame,ident,x,y,r,r,90,0,1,2,vx,vy,2]

class ModelTests(unittest.TestCase):
    def test_fast_bullet_has_smaller_timing_margin(self):
        p=Parameters();x=np.array([0.])
        slow=profile(np.array([bullet(2,1,8,-176,vy=-1)]),x,p)[0][0]
        fast=profile(np.array([bullet(2,1,8,-176,vy=-5)]),x,p)[0][0]
        self.assertGreater(fast,slow)
        self.assertGreater(profile(np.array([bullet(2,1,8,-176,vy=-5)]),x,p)[3][0],profile(np.array([bullet(2,1,8,-176,vy=-1)]),x,p)[3][0])

    def test_layer_overlap_is_not_screen_count(self):
        p=Parameters();x=np.array([0.])
        one=np.array([bullet(2,1,8,-176)])
        remote=np.array([bullet(2,1,8,-176),bullet(2,2,170,160)])
        two=np.array([bullet(2,1,8,-176),bullet(2,2,-8,-176)])
        self.assertAlmostEqual(profile(one,x,p)[0][0],profile(remote,x,p)[0][0])
        self.assertGreater(profile(two,x,p)[2][0],profile(one,x,p)[2][0])

    def test_gap_width_uses_surface_and_connected_regions(self):
        np.testing.assert_equal(gap_width(np.array([2,1,-1,1,2,1,-2]),2),[4,4,0,6,6,6,0])

    def test_sampling_cannot_miss_a_fast_crossing(self):
        p=Parameters();x=np.array([0.])
        # 现在位于 x=8，上一采样位于 x=-8；两个端点都没压住自机，但途中已穿过。
        row=np.array([bullet(2,1,8,-176,vx=8,vy=0)])
        self.assertLess(profile(row,x,p)[1][0],0)

    def test_future_newborn_is_not_visible_to_planner(self):
        row=np.array([bullet(20,1,0,-176)])
        flow,_,_,_=profile(row,np.array([0.]),Parameters(),cutoff=10,born=np.array([np.inf,20]))
        self.assertEqual(flow[0],0)

    def test_route_cannot_teleport_through_a_wall(self):
        costs=np.zeros((12,15));costs[:,7]=BARRIER;costs[:,10:]=-.1
        route=path_dp(costs,3,3)
        self.assertLessEqual(np.abs(np.diff(route)).max(),3)
        self.assertTrue(np.all(route<7))

    def test_scatter_measures_dispersed_parallel_births(self):
        aligned=np.array([bullet(2,i,x,100) for i,x in enumerate([0,1,2],1)])
        scattered=np.array([bullet(2,i,x,100) for i,x in enumerate([-60,0,60],1)])
        self.assertGreater(emission_scatter([scattered]),emission_scatter([aligned]))

if __name__=='__main__':unittest.main()
