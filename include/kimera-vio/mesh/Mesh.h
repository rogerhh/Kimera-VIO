/* ----------------------------------------------------------------------------
 * Copyright 2017, Massachusetts Institute of Technology,
 * Cambridge, MA 02139
 * All Rights Reserved
 * Authors: Luca Carlone, et al. (see THANKS for the full author list)
 * See LICENSE for the license information
 * -------------------------------------------------------------------------- */

/**
 * @file   Mesher.h
 * @brief  Represents a Mesh of polygons in 3D
 * @author Antoni Rosinol
 */

#pragma once

#include <map>
#include <vector>

#include <opencv2/core/core.hpp>
#include <opencv2/core/mat.hpp>
#include <opencv2/viz/types.hpp>  // Just for color type.

#include "kimera-vio/utils/Macros.h"
#include "kimera-vio/utils/SerializationOpenCv.h"
#include "kimera-vio/utils/UtilsOpenCV.h"

namespace VIO {

// TODO this class is NOT THREADSAFE...
// Class defining the concept of a polygonal mesh.
template <typename VertexPosition = cv::Point3f>
class Mesh {
 public:
  KIMERA_POINTER_TYPEDEFS(Mesh);
  // Color for a vertex
  typedef cv::Vec3b VertexColorRGB;
  // Normal for a vertex
  typedef cv::Point3f VertexNormal;
  typedef std::vector<VertexNormal> VertexNormals;

 public:
  // Default constructor.
  Mesh(const size_t& polygon_dimension = 3);

  // Delete copy constructor.
  // Performs a deep copy (clones) the data members.
  Mesh(const Mesh& rhs_mesh);

  // Copy assignement operator.
  // Performs a deep copy (clones) the data members.
  Mesh& operator=(const Mesh& mesh);

  // Use default move constructor.
  // TODO define explicitly what the move ctor shall look like.
  Mesh(Mesh&& mesh) = default;

  // Delete move assignement operator.
  Mesh& operator=(Mesh&& mesh) = delete;

  // Destructor.
  ~Mesh() = default;

 private:
  // Vertex id (for internal processing).
  typedef int VertexId;
  // Maps (for internal processing).
  typedef std::map<VertexId, LandmarkId> VertexToLmkIdMap;
  typedef std::map<LandmarkId, VertexId> LmkIdToVertexMap;

 public:
  template <typename PositionType = cv::Point3f>
  struct Vertex {
   public:
    Vertex()
        : lmk_id_(-1),
          vertex_position_(),
          vertex_normal_(),
          vertex_color_(cv::viz::Color::white()) {}

    Vertex(const LandmarkId& lmk_id,
           const VertexPosition& vertex_position,
           const VertexNormal& vertex_normal = VertexNormal(),
           const VertexColorRGB& vertex_color = cv::viz::Color::white())
        : lmk_id_(lmk_id),
          vertex_position_(vertex_position),
          vertex_normal_(vertex_normal),
          vertex_color_(vertex_color) {}

    // Make explicit that we are using the default copy constructor and
    // copy assignement operator.
    Vertex(const Vertex& rhs_mesh_vertex) = default;
    Vertex& operator=(const Vertex& rhs_mesh_vertex) = default;

    // Make explicit that we are using the default move constructor and
    // move assignement operator.
    Vertex(Vertex&& rhs_mesh_vertex) = default;
    Vertex& operator=(Vertex&& rhs_mesh_vertex) = default;

    // Default destructor.
    ~Vertex() = default;

    /// Getters.
    inline const VertexPosition& getVertexPosition() const {
      return vertex_position_;
    }
    inline const VertexNormal& getVertexNormal() const {
      return vertex_normal_;
    }
    inline const VertexColorRGB& getVertexColor() const {
      return vertex_color_;
    }
    inline const LandmarkId& getLmkId() const { return lmk_id_; }
    /// Setters.
    inline void setVertexPosition(const VertexPosition& position) {
      vertex_position_ = position;
    }

   private:
    /// Members
    LandmarkId lmk_id_;
    VertexPosition vertex_position_;
    VertexNormal vertex_normal_;
    VertexColorRGB vertex_color_;
  };
  // We define a polygon of the mesh as a set of mesh vertices.
  typedef Vertex<VertexPosition> VertexType;
  // TODO(Toni): a polygon could also contain a normal...
  typedef std::vector<VertexType> Polygon;

 public:
  // Adds a new polygon into the mesh, updates the internal data structures.
  void addPolygonToMesh(const Polygon& polygon);

  // Completely clears the mesh.
  void clearMesh();

  /// Getters
  inline size_t getNumberOfPolygons() const {
    return static_cast<size_t>(polygons_mesh_.rows / (polygon_dimension_ + 1));
  }
  inline size_t getNumberOfUniqueVertices() const {
    return vertices_mesh_.rows;
  }
  // TODO needs to be generalized to aleatory polygonal meshes.
  // Currently it only allows polygons of same size.
  inline size_t getMeshPolygonDimension() const { return polygon_dimension_; }

  // Retrieve the mesh data structures.
  void convertVerticesMeshToMat(cv::Mat* vertices_mesh) const;
  void convertPolygonsMeshToMat(cv::Mat* polygons_mesh) const;

  // Retrieve a single polygon in the mesh.
  // Iterate over the total number of polygons (given by getNumberOfPolygons)
  // to retrieve one polygon at a time.
  bool getPolygon(const size_t& polygon_idx, Polygon* polygon) const;

  // Retrieve a vertex or internal vertex_id.
  // (optionally, call with nullptr if you don't want the info) from the mesh
  // given a LandmarkId.
  // Returns true if we could find the vertex with the given landmark id
  // false otherwise.
  // The internal vertex id used to store the vertex in
  // a cv::Mat (TODO this is only done to be able to create a color mask of
  // the mesh, but this should be also done internally by storing a set of
  // properties for each vertex, instead of using cv::Mat).
  bool getVertex(const LandmarkId& lmk_id,
                 Vertex<VertexPosition>* vertex = nullptr,
                 VertexId* vertex_id = nullptr) const;

  /* ------------------------------------------------------------------------ */
  // Calculate normal of a triangle, and return whether it was possible or not.
  // Calculating the normal of aligned points in 3D is not possible...
  static bool getTriangleNormal(const cv::Point3f& p1,
                                const cv::Point3f& p2,
                                const cv::Point3f& p3,
                                VertexNormal* normal);

  // NOT TESTED
  void computePerVertexNormals();

  // NOT THREADSAFE.
  // Colors a vertex of the mesh given a LandmarkId.
  // Returns true if we could find the vertex with the given landmark id
  // false otherwise.
  bool setVertexColor(const LandmarkId& lmk_id, const VertexColorRGB& vertex);
  // NOT THREADSAFE.
  // Updates position of a vertex of the mesh given a LandmarkId.
  // Returns true if we could find the vertex with the given landmark id
  // false otherwise.
  bool setVertexPosition(const LandmarkId& lmk_id,
                         const VertexPosition& vertex);

  // Get a list of all lmk ids in the mesh.
  LandmarkIds getLandmarkIds() const;

 private:
  /// Functions
  // Updates internal structures to add a vertex.
  // Used by addPolygonToMesh, it is not supposed to be used by the end user.
  void updateMeshDataStructures(
      const LandmarkId& lmk_id,
      const VertexPosition& lmk_position,
      std::map<VertexId, LandmarkId>* vertex_to_lmk_id_map,
      std::map<LandmarkId, VertexId>* lmk_id_to_vertex_map,
      cv::Mat* vertices_mesh,
      VertexNormals* vertices_mesh_normal,
      cv::Mat* vertices_mesh_color,
      cv::Mat* polygon_mesh,
      const VertexColorRGB& vertex_color = cv::viz::Color::white()) const;

  // Sets all vertex normals to 0.
  inline void clearVertexNormals() { vertices_mesh_normal_.clear(); }

  friend class boost::serialization::access;
  // When the class Archive corresponds to an output archive, the
  // & operator is defined similar to <<.  Likewise, when the class Archive
  // is a type of input archive the & operator is defined similar to >>.
  template <class Archive>
  void serialize(Archive& ar, const unsigned int version) {
    ar& vertex_to_lmk_id_map_;
    ar& lmk_id_to_vertex_map_;
    ar& vertices_mesh_;
    ar& vertices_mesh_normal_;
    ar& normals_computed_;
    ar& vertices_mesh_color_;
    ar& polygons_mesh_;
    ar& const_cast<size_t&>(polygon_dimension_);
  }

 private:
  /// TODO change internal structures for the mesh with std::vector<Polygon>.

  /// Members
  /// TODO maybe use bimap.
  // Vertex to LmkId Map
  VertexToLmkIdMap vertex_to_lmk_id_map_;

  // LmkId to Vertex Map
  LmkIdToVertexMap lmk_id_to_vertex_map_;

  // Vertices 3D.
  // Set of (non-repeated) 3d points.
  // Format: n rows (one for each point), with each row being a cv::Point3f.
  cv::Mat vertices_mesh_;

  // Normal for each vertex
  // Format: n rows (one for each point), with each row being a CV_32FC3.
  // where n should be the same number as rows for vertices_mesh_.
  // One normal per vertex.
  VertexNormals vertices_mesh_normal_;
  // If the normals have been computed;
  bool normals_computed_ = false;

  // Color for each vertex.
  // Format: n rows (one for each point), with each row being a CV_8UC3.
  // where n should be the same number as rows for vertices_mesh_.
  // One color per vertex. (This is how it is done for OpenCV...
  cv::Mat vertices_mesh_color_;

  // Connectivity of the mesh.
  // Set of polygons.
  // Raw integer list of the form: (n,id1_a,id2_a,...,idn_a,
  // n,id1_b,id2_b,...,idn_b, ..., n, ... idn_x)
  // where n is the number of points per polygon, and id is a zero-offset
  // index into the associated row in vertices_mesh_.
  cv::Mat polygons_mesh_;

  // Number of vertices per polygon.
  const size_t polygon_dimension_;
};

// For example, pixels.
typedef cv::Point2f Vertex2D;
// A 2D Mesh of pixels.
typedef Mesh<Vertex2D> Mesh2D;

// For example, landmark positions.
typedef cv::Point3f Vertex3D;
// A 3D Mesh of landmarks.
typedef Mesh<Vertex3D> Mesh3D;

inline Mesh3D::VertexType convertVertex2dTo3d(
    const Mesh2D::VertexType& vtx_2d,
    const float& z = 1.0f) {
  Vertex2D vtx_position_2d = vtx_2d.getVertexPosition();
  Vertex3D vtx_position_3d (vtx_position_2d.x, vtx_position_2d.y, z);
  return Mesh3D::VertexType(vtx_2d.getLmkId(),
                            vtx_2d.getVertexNormal(),
                            vtx_position_3d,
                            vtx_2d.getVertexColor());
}

inline Mesh3D convertMesh2dTo3d(const Mesh2D& mesh_2d,
                                const float& z = 1.0f) {
  Mesh2D::Polygon polygon_2d;
  Mesh3D::Polygon polygon_3d;
  Mesh3D mesh_3d;
  for (size_t tri_idx = 0; tri_idx < mesh_2d.getNumberOfPolygons(); tri_idx++) {
    CHECK(mesh_2d.getPolygon(tri_idx, &polygon_2d));
    CHECK_EQ(polygon_2d.size(), 3);
    polygon_3d[0] = convertVertex2dTo3d(polygon_2d[0], z);
    polygon_3d[1] = convertVertex2dTo3d(polygon_2d[1], z);
    polygon_3d[2] = convertVertex2dTo3d(polygon_2d[2], z);
    mesh_3d.addPolygonToMesh(polygon_3d);
  }
  return mesh_3d;
}

}  // namespace VIO
