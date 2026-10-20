"""Generates layout/Assembly-CSharp.map.

The shipped TypeDef order is the only layout evidence: Unity 4.3.2 compiles script
files in ordinal path order, so any paths whose sorted order reproduces the TypeDef
order rebuild the same assembly. Original folder names are not recorded in the
player build; folders here are named after the package or subsystem their types
belong to, with a two-digit prefix that enforces the observed order. Types share a
file only where the observed order requires it (helper types that sort out of
place, e.g. the JPGEncoder.cs helper classes or the IMGFormat enum of MegaGrab)."""
import os

# (folder, [file entries]); a file entry is "[@FileName] TypeA TypeB ..." (default: the first type names the file).
groups = [
    ('01 ProBuilder/API Examples', ['ProBuilderInstantiate', 'pb_Selection']),
    ('02 ProBuilder/Runtime', ['RuntimeEdit', 'pbVersionBridge']),
    ('03 ProGrids', ['GameObjectExtensions', 'pg_Util PGExtensions']),
    ('04 Circular Gravity', ['CircularGravity', 'CircularGravityGizmos', 'CircularGravityVisualizer',
        'EnableCircularGravityControls', 'LookAtObject', 'MoveVacuum', 'RollControls', 'RotateAround',
        'RotateControls', 'SceneTimeScale', 'Shoot', 'ShowHelpInfo', 'Spawn', 'WorldGravity']),
    ('05 Colorful', ['CC_AnalogTV', 'CC_Base', 'CC_BleachBypass', 'CC_Blend', 'CC_BrightnessContrastGamma',
        'CC_ChannelMixer', 'CC_Convolution3x3', 'CC_DoubleVision', 'CC_FastVignette', 'CC_Frost',
        'CC_GradientRamp', 'CC_Grayscale', 'CC_HueSaturationValue', 'CC_Led', 'CC_Levels', 'CC_LookupFilter',
        'CC_Negative', 'CC_PhotoFilter', 'CC_Pixelate', 'CC_Posterize', 'CC_RGBSplit', 'CC_RadialBlur',
        'CC_Sharpen', 'CC_Threshold', 'CC_Vibrance', 'CC_Wiggle']),
    ('06 Destruction/Demo', ['Destruction.Cannon', 'Destruction.GUIController']),
    ('07 Destruction/Dynamic/Box', ['Destruction.Dynamic.BoxFracture']),
    ('08 Destruction/Common', ['Destruction.Common.BaseDestructable', 'CreationSingleton`1']),
    ('09 Destruction/Dynamic', ['Destruction.Dynamic.BaseFracture', 'Destruction.Dynamic.Shard', 'Destruction.Dynamic.ShardPool']),
    ('10 Destruction/Common/Ranges', ['Destruction.RangedInt']),
    ('11 Destruction/Helpers', ['Destruction.DestructionHelper', 'Destruction.Common.RangedFloat']),
    ('12 Destruction/Interfaces', ['Destruction.Common.IDestructable']),
    ('13 Destruction/Tools', ['Destruction.Dynamic.ConvexFracture', 'Destruction.Tools.DestroyMeOffscreen',
        'Destruction.Tools.IDamagable', 'Destruction.Tools.IDestructionAffectable',
        'Destruction.Tools.LinkObjectsOnDestroy', 'RigidJoint']),
    ('14 Destruction/Tools/Scheduling', ['Destruction.Tools.ISchedulable', 'Destruction.Tools.Scheduler',
        'Destruction.Tools.StickyZone', 'Destruction.Tools.Trigger']),
    ('15 Destruction/Utilities/FloodFiller', ['Destruction.Utilities.FloodFiller.BaseFloodFiller`1',
        'Destruction.Utilities.FloodFiller.FloodFiller2', 'Destruction.Utilities.FloodFiller.FloodFiller3']),
    ('16 Destruction/Utilities', ['Destruction.Utilities.Face', 'Destruction.Utilities.MeshUtility',
        'Destruction.Utilities.int2', 'Destruction.Utilities.int3']),
    ('17 Marmoset/Demo', ['MopedDemo', 'ProbeDemo', 'SkySwab']),
    ('18 Marmoset/Legacy', ['Sky']),
    ('19 Marmoset/Skyshop', ['mset.Corner', 'mset.Logo', 'mset.SHEncoding', 'mset.Sky']),
    ('20 MGBlendTable', ['MGBlendTable']),
    ('21 DOFCamera', ['DOFCamera']),
    ('22 MegaGrab', ['@JPGEncoder ByteArray BitString BitmapData JPGEncoder', '@MegaGrab IMGFormat MegaGrab', 'MicrophoneSource']),
    ('23 Gang Beasts/Effects', ['AudioTimeScale', 'Blood', 'BloodSpray', 'Boom', 'Bounce', 'CameraController', 'DontTrackZone']),
    ('24 Gang Beasts/Environment', ['CameraShake', 'GlassBreak', 'Grass', 'KillZone', 'LightFlicker', 'Respawn',
        'WarpZone', 'Water', 'Wind', 'Window']),
    ('25 Gang Beasts/Environment/Machines', ['Escalator', 'FlameFlicker']),
    ('26 Gang Beasts/GUI', ['CameraFade', 'LaunchBindingWindow']),
    ('27 Gang Beasts/GUI/HUD', ['HUDFPS', 'Lift', 'MenuController']),
    ('28 Gang Beasts/Player', ['Blink', 'CollisionEvent', 'HealthAndStamina', 'Jump', 'MassOffset', 'Mob', 'Movement',
        'Player', 'PrintCollision', 'PunchAndGrab', 'SceneManager', 'StatusBar', 'Targeting']),
    ('29 Gang Beasts/Menus', ['Exit', 'Intro', 'Level', 'Music', 'MuteMusic', 'Players', 'Rezzed', 'ScrollUVs',
        'StartGame', 'Website']),
    ('30 Gang Beasts/Levels/Road', ['Road', 'RoadSpawnObject', 'RoadSpawnObjectMover', 'RopeBreak', 'SceneCamera', 'SetBreakable']),
    ('31 Gang Beasts/Utilities', ['AnimatedTextureOffset', 'Arrow', 'InputManager', 'LaunchPadController',
        'SetRenderQueue', 'SkinnedMeshCombiner', 'Wheel', 'test']),
    ('32 Gang Beasts/Levels/Train', ['Teleporter', 'Timer', 'TrackChange', 'TrainStop', 'Truck', 'WaveTrigger']),
    ('33 Ultimate Fracturing/Poly2Tri', ['Poly2Tri.P2T']),
    ('34 Ultimate Fracturing/Poly2Tri/Triangulation/Delaunay', ['Poly2Tri.DelaunayTriangle']),
    ('35 Ultimate Fracturing/Poly2Tri/Triangulation/Delaunay/Sweep', ['Poly2Tri.AdvancingFront', 'Poly2Tri.AdvancingFrontNode',
        'Poly2Tri.DTSweep', 'Poly2Tri.DTSweepBasin', 'Poly2Tri.DTSweepConstraint', 'Poly2Tri.DTSweepContext',
        'Poly2Tri.DTSweepDebugContext', 'Poly2Tri.DTSweepEdgeEvent', 'Poly2Tri.DTSweepPointComparator',
        'Poly2Tri.PointOnEdgeException']),
    ('36 Ultimate Fracturing/Poly2Tri/Triangulation', ['Poly2Tri.ITriangulatable', 'Poly2Tri.Orientation']),
    ('37 Ultimate Fracturing/Poly2Tri/Triangulation/Polygon', ['Poly2Tri.Contour', 'Poly2Tri.Polygon', 'Poly2Tri.PolygonPoint',
        'Poly2Tri.PolygonSet',
        'Poly2Tri.PolygonUtil Poly2Tri.EdgeIntersectInfo Poly2Tri.SplitComplexPolygonNode Poly2Tri.PolygonOperationContext']),
    ('38 Ultimate Fracturing/Poly2Tri/Triangulation/Sets', ['Poly2Tri.ConstrainedPointSet', 'Poly2Tri.PointSet',
        'Poly2Tri.TriangulationAlgorithm']),
    ('39 Ultimate Fracturing/Poly2Tri/Triangulation/Core', ['Poly2Tri.Edge', 'Poly2Tri.TriangulationConstraint',
        'Poly2Tri.TriangulationContext', 'Poly2Tri.TriangulationDebugContext', 'Poly2Tri.TriangulationMode',
        'Poly2Tri.TriangulationPoint', 'Poly2Tri.TriangulationPointEnumerator', 'Poly2Tri.TriangulationPointList']),
    ('40 Ultimate Fracturing/Poly2Tri/Triangulation/Util', ['Poly2Tri.PointGenerator', 'Poly2Tri.PolygonGenerator',
        'Poly2Tri.TriangulationUtil']),
    ('41 Ultimate Fracturing/Poly2Tri/Utility', ['Poly2Tri.FixedArray3`1', 'Poly2Tri.FixedBitArray3', 'Poly2Tri.MathUtil',
        'Poly2Tri.Point2D', 'Poly2Tri.Point2DEnumerator', 'Poly2Tri.Point2DList', 'Poly2Tri.Rect2D']),
    ('42 Ultimate Fracturing/Demos', ['LogicArcsAndColumns', 'LogicCollidingSphere', 'LogicCompoundObject',
        'LogicExplodingFloor', 'LogicExplodingGoblin', 'LogicGlobalFracturing', 'UltimateFracturingFPS']),
    ('43 Ultimate Fracturing/Scripts', ['UltimateFracturing.ConcaveColliderInterface', 'ExplosionSource', 'UltimateFracturing.Fracturer']),
    ('44 Ultimate Fracturing/Scripts/Objects', ['FracturedChunk', 'FracturedObject']),
    ('45 Ultimate Fracturing/Scripts/Internal', ['UltimateFracturing.DieTimer', 'UltimateFracturing.Parameters',
        'UltimateFracturing.VertexData UltimateFracturing.EdgeKeyByIndex UltimateFracturing.EdgeKeyByHash '
        'UltimateFracturing.ClippedEdge UltimateFracturing.CapEdge UltimateFracturing.MeshFaceConnectivity '
        'UltimateFracturing.MeshDataConnectivity UltimateFracturing.MeshData UltimateFracturing.SupportPlane']),
    ('46 Mesh Utilities', ['CombinedMesh']),
    ('47 cInput Demo', ['cInputDemoBoss', 'cInputDemoBullet', 'cInputDemoDestroy', 'cInputDemoEnemy', 'cInputDemoPlanes',
        'cInputDemoRestart', 'cInputDemoRocket', 'cInputDemoSetup', 'cInputDemoTurret']),
]

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'Assembly-CSharp.map')
with open(out, 'w', newline='\n') as f:
    f.write('# Assembly-CSharp: paths under Assets/ (generated by gen_csharp_map.py).\n')
    for folder, files in groups:
        for entry in files:
            types = entry.split()
            # "@Name" names the file after a MonoBehaviour that is not the first declared type
            # (Unity requires a MonoBehaviour's file to carry its class name).
            if types[0].startswith('@'):
                fname = types.pop(0)[1:] + '.cs'
            else:
                fname = types[0].split('.')[-1].split('`')[0] + '.cs'
            f.write(f'Scripts/{folder}/{fname}: {" ".join(types)}\n')
