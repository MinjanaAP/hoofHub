'use client';

import * as React from 'react';
import {
  Avatar,
  Box,
  Card,
  Checkbox,
  Divider,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TablePagination,
  TableRow,
  Typography,
} from '@mui/material';
import dayjs from 'dayjs';
import apikey from '@/constants/apikey';

interface Guide {
  id: string;
  fullName: string;
  email: string;
  mobileNumber: string;
  createdAt: string;
  profileImage: string;
  address: string;
  horse: {
    name: string;
    breed: string;
  };
}

interface Rider {
  id: string;
  name: string;
  email: string;
  mobileNumber: string;
  createdAt: string;
}

function UserTable<T extends { id: string }>(props: {
  title: string;
  rows: T[];
  columns: React.ReactNode;
  renderRow: (row: T) => React.ReactNode;
}) {
  const [page, setPage] = React.useState(0);
  const [rowsPerPage, setRowsPerPage] = React.useState(5);
  const paginatedRows = props.rows.slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage);

  return (
    <Card sx={{ my: 4 }}>
      <Typography variant="h6" sx={{ p: 2 }}>{props.title}</Typography>
      <Divider />
      <Box sx={{ overflowX: 'auto' }}>
        <Table>
          <TableHead>{props.columns}</TableHead>
          <TableBody>{paginatedRows.map((row) => props.renderRow(row))}</TableBody>
        </Table>
      </Box>
      <Divider />
      <TablePagination
        component="div"
        count={props.rows.length}
        page={page}
        onPageChange={(_, newPage) => setPage(newPage)}
        rowsPerPage={rowsPerPage}
        onRowsPerPageChange={(e) => setRowsPerPage(parseInt(e.target.value, 10))}
        rowsPerPageOptions={[5, 10, 25]}
      />
    </Card>
  );
}

const baseUrl = apikey.baseUrl;

export default function AdminUsersPage(): React.JSX.Element {
  const [guides, setGuides] = React.useState<Guide[]>([]);
  const [riders, setRiders] = React.useState<Rider[]>([]);

  React.useEffect(() => {
    fetch(`${baseUrl}/api/guides`)
      .then((res) => res.json())
      .then(setGuides)
      .catch(console.error);

    fetch(`${baseUrl}/api/riders`)
      .then((res) => res.json())
      .then(setRiders)
      .catch(console.error);
  }, []);

  return (
    <Box sx={{ px: 2 }}>
      <UserTable
        title="Guide Accounts"
        rows={guides}
        columns={
          <TableRow>
            <TableCell>Profile</TableCell>
            <TableCell>Email</TableCell>
            <TableCell>Mobile</TableCell>
            <TableCell>Horse</TableCell>
            <TableCell>Address</TableCell>
            <TableCell>Joined</TableCell>
          </TableRow>
        }
        renderRow={(guide) => (
          <TableRow key={guide.id}>
            <TableCell>
              <Stack direction="row" spacing={2} alignItems="center">
                <Avatar src={guide.profileImage} />
                <Typography>{guide.fullName}</Typography>
              </Stack>
            </TableCell>
            <TableCell>{guide.email}</TableCell>
            <TableCell>{guide.mobileNumber}</TableCell>
            <TableCell>{guide.horse?.name} ({guide.horse?.breed})</TableCell>
            <TableCell>{guide.address}</TableCell>
            <TableCell>{dayjs(guide.createdAt).format('MMM D, YYYY')}</TableCell>
          </TableRow>
        )}
      />

      <UserTable
        title="Rider Accounts"
        rows={riders}
        columns={
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Email</TableCell>
            <TableCell>Mobile</TableCell>
            <TableCell>Joined</TableCell>
          </TableRow>
        }
        renderRow={(rider) => (
          <TableRow key={rider.id}>
            <TableCell>{rider.name}</TableCell>
            <TableCell>{rider.email}</TableCell>
            <TableCell>{rider.mobileNumber}</TableCell>
            <TableCell>{dayjs(rider.createdAt).format('MMM D, YYYY')}</TableCell>
          </TableRow>
        )}
      />
    </Box>
  );
}
