import React from "react";
import { Box, Card, CardContent, CardMedia, Typography, Grid, CircularProgress, Alert } from "@mui/material";
import apikey from "@/constants/apikey";
import axios from "axios";

interface Ride {
  title: string;
  description: string;
  location: string;
  duration: string;
  distance: string;
  price: string;
  rating: string;
  reviews: string;
  includes: string[];
  maxParticipants: string;
  specifications: {
    ageLimit: string;
    difficulty: string;
    language: string;
  };
  expect: string;
  route: { start: string; end: string };
  additionalInfo: string[];
  cancelPolicy: string;
  contact: string;
  images?: string[];
  [key: string]: any;
}

const RidesList: React.FC = () => {
  const [rides, setRides] = React.useState<Ride[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState("");

  React.useEffect(() => {
    const fetchRides = async () => {
      setLoading(true);
      setError("");
      try {
        const res = await axios.get(`${apikey.baseUrl}/api/rides`);
        setRides(res.data || []);
      } catch (err: any) {
        setError(err?.response?.data?.error || err.message || "Failed to fetch rides");
      } finally {
        setLoading(false);
      }
    };
    fetchRides();
  }, []);

  if (loading) return <Box display="flex" justifyContent="center" my={4}><CircularProgress /></Box>;
  if (error) return <Alert severity="error">{error}</Alert>;
  if (!rides.length) return <Alert severity="info">No rides found.</Alert>;

  return (
    <Box>
      <Typography variant="h5" mb={2} fontWeight={700}>All Rides</Typography>
      <Grid container spacing={3}>
        {rides.map((ride, idx) => (
          <Grid item xs={12} sm={6} md={4} key={idx}>
            <Card sx={{ height: "100%", display: "flex", flexDirection: "column" }}>
              {ride.images && ride.images.length > 0 && (
                <CardMedia
                  component="img"
                  height="180"
                  image={ride.images[0]}
                  alt={ride.title}
                  sx={{ objectFit: "cover" }}
                />
              )}
              <CardContent>
                <Typography variant="h6" fontWeight={600} gutterBottom>{ride.title}</Typography>
                <Typography variant="body2" color="text.secondary" gutterBottom>{ride.description}</Typography>
                <Typography variant="subtitle2" color="primary" gutterBottom>{ride.location}</Typography>
                <Box mt={1} mb={1}>
                  <Typography variant="body2">Duration: {ride.duration} | Distance: {ride.distance}</Typography>
                  <Typography variant="body2">Price: ${ride.price} | Max Participants: {ride.maxParticipants}</Typography>
                  <Typography variant="body2">Rating: {ride.rating} ({ride.reviews} reviews)</Typography>
                </Box>
                <Typography variant="body2" color="text.secondary">Includes: {ride.includes?.join(", ")}</Typography>
                <Typography variant="body2" color="text.secondary">Specs: {ride.specifications?.ageLimit}, {ride.specifications?.difficulty}, {ride.specifications?.language}</Typography>
                <Typography variant="body2" color="text.secondary" mt={1}>Contact: {ride.contact}</Typography>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default RidesList; 